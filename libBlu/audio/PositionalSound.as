package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * A positional sound in the world. When we play it, and our reference object is outside the
	 * outer radius, and the volume is 0.0, then the sound itself will be stopped and exist only
	 * in memory, to be played again at the proper place when the reference object returns to the
	 * outer radius limits.
	 * The sound will be scaled linearly from the outer to the inner radius, and we can also define
	 * an angle for the sound so that it plays only in one direction
	 * @author Damian Connolly
	 */
	public class PositionalSound
	{
		
		/********************************************************************************/
		
		/**
		 * Should we clear SoundChannels that have a volume of 0.0. The sound will continue
		 * "playing" in memory. Setting this to true means that you can have more than the
		 * maximum number of SoundChannels (currently 32), and you'll save some processing.
		 * Setting this to false will mean that the sound tracking (position) will be more
		 * accurate, and you won't have to deal with potential issues to do with looping
		 * (as we can specify the loops rather than play, listen for the stop, then play
		 * again)
		 */
		public static var shouldClearZeroVolumeSounds:Boolean = false;
		
		/********************************************************************************/
		
		private static var m_helperPoint:Point = new Point; // a helper point used when calculating if we're inside our cones/clipRect
		
		/********************************************************************************/
		
		private var m_sound:Sound						= null;	// the sound that this class is for
		private var m_transform:SoundTransform			= null; // the sound transform object that we'll use to modify our volume etc
		private var m_channel:SoundChannel				= null; // the sound channel that we're currently playing
		private var m_pos:Point							= null;	// the position of our sound in the world
		private var m_prevPos:Point						= null;	// a point used to see if our position has changed
		private var m_followObj:DisplayObject			= null;	// an object to follow, if we should move automatically
		private var m_refObj:DisplayObject				= null;	// the reference object, that we'll use to adjust our volume and pan
		private var m_refPos:Point						= null;	// the reference point, that we'll use to adjust our volume and pan
		private var m_prevRefPos:Point					= null;	// a point used to see if our reference position has changed
		private var m_prevRefObjRotation:Number			= 0.0;	// used to see if our reference object rotation has changed
		private var m_rotation:Number					= 0.0;	// the rotation of the sound
		private var m_rotationRads:Number				= 0.0;	// the rotation of the sound, in radians
		private var m_innerRadius:Number 				= 0.0; 	// the inner radius for the sound - volume is at 100% here
		private var m_outerRadius:Number 				= 0.0;	// the outer radius for the sound - volume is a outerRadiusVolume and scales up
		private var m_innerAngle:Number					= 0.0;	// the inner angle for our sound
		private var m_outerAngle:Number					= 0.0;	// the outer angle for our sound
		private var m_volume:Number						= 0.0;	// the max volume for the sound, when our reference obj/pos is inside the innerRadius
		private var m_currVolume:Number					= 0.0;	// the current volume for the sound
		private var m_outerRadiusVolume:Number			= 0.0;	// the volume for when our reference obj/pos is outside the outerRadius
		private var m_fadeVolume:Number					= 0.0;	// a separate volume to control the fade of the sound (e.g. if we want to have a global sound volume level)
		private var m_panType:PositionalSoundPanType	= null; // the type that describes how to deal with pan for the object
		private var m_currPan:Number					= 0.0;	// the current pan for the sound
		private var m_maxPan:Number						= 0.0;	// the max pan that we can have, on either channel
		private var m_posVolLimit:Number				= 0.0;	// the limit at which we consider a sound being "behind" us, for positional volume
		private var m_posVolMult:Number					= 0.0;	// the mult that we apply for sounds "behind" us, for positional volume
		private var m_position:Number					= 0.0;	// the position of the sound
		private var m_startTime:Number					= 0.0;	// the start time that we'll loop back to
		private var m_isPaused:Boolean					= false;// is the sound paused?
		private var m_isPlaying:Boolean					= false;// is the sound playing?
		private var m_loops:uint						= 0;	// the number of times to loop the sound
		private var m_clipRect:Rectangle				= null;	// the clip rect, to clip our sound boundaries
		private var m_clipRectRotation:Number			= 0.0;	// the rotation of the clip rect
		private var m_clipRectRotationRads:Number		= 0.0;	// the rotation of the clip rect, in radians
		private var m_isClipRectInversed:Boolean		= false;// is the clip rect inversed (i.e. we hear when we're *outside* of it)
		private var m_isDirty:Boolean					= false;// to know if we need to update or not
		
		/********************************************************************************/
		
		/**
		 * The actual Sound object that this PositionalSound is for. Setting this will clear
		 * any SoundChannel currently playing for us
		 */
		public function get sound():Sound { return this.m_sound; }
		public function set sound( s:Sound ):void
		{
			if ( this.m_channel != null )
				this.stop();
			this.m_sound 	= s;
			this.m_isDirty	= true;
		}
		
		/**
		 * The position of our sound in the world
		 */
		public function get pos():Point { return this.m_pos; }
		public function set pos( p:Point ):void
		{
			this.m_pos 		= p;
			this.m_isDirty	= true;
		}
		
		/**
		 * An object to follow, if this sound should move around automatically. E.g. a ship, or a
		 * player object. If you would prefer to follow a Point instead, just set the pos property
		 * to the Point you want to follow, and it'll get updated automatically
		 */
		public function get followObj():DisplayObject { return this.m_followObj; }
		public function set followObj( d:DisplayObject ):void
		{
			this.m_followObj 	= d;
			this.m_isDirty		= true;
		}
		
		/**
		 * The reference object, that we'll use to adjust our volume and panning etc. If refObj
		 * and refPos are null, then no sound will be heard. refObj is preferred to refPos. When
		 * calculating reference positions, it's assumed that refObj is in the same relative
		 * coordinate space
		 */
		public function get refObj():DisplayObject { return this.m_refObj; }
		public function set refObj( d:DisplayObject ):void
		{
			this.m_refObj 	= d;
			this.m_isDirty	= true;
		}
		
		/**
		 * The reference point, that we'll use to adjust our volume and panning etc. If refObj
		 * and refPos are null, then the volume will be set to 0.0. When calculating 
		 * reference positions, it's assumed that refPos is in the same relative coordinate space
		 */
		public function get refPos():Point { return this.m_refPos; }
		public function set refPos( p:Point ):void
		{
			this.m_refPos 	= p;
			this.m_isDirty	= true;
		}
		
		/**
		 * The rotation of the sound, in degrees. 0.0 to 180.0 represents clockwise
		 * rotation, while 0.0 to -180.0 represents counter-clockwise rotation. Values
		 * will be limited to -180.0/180.0 range
		 */
		public function get rotation():Number { return this.m_rotation; }
		public function set rotation( n:Number ):void
		{
			this.m_rotation = n;
			this.m_isDirty	= true;
			
			// clamp between -180 and 180
			while ( this.m_rotation < -180.0 )
				this.m_rotation += 360.0;
			while ( this.m_rotation > 180.0 )
				this.m_rotation -= 360.0;
				
			// get our rotation in radians
			this.m_rotationRads = MathHelper.degreesToRadians( this.m_rotation );
		}
		
		/**
		 * The inner radius for the sound. When the reference object is within this radius, the
		 * sound will be at 100% volume. If the inner radius is set to be larger than the outer
		 * radius, the outer radius will be increased to match
		 */
		public function get innerRadius():Number { return this.m_innerRadius; }
		public function set innerRadius( n:Number ):void
		{
			this.m_innerRadius 	= ( n < 0.0 ) ? 0.0 : n;
			this.m_isDirty		= true;
			if ( this.m_innerRadius > this.m_outerRadius )
				this.outerRadius = this.m_innerRadius;
		}
		
		/**
		 * The outer radius for the sound. When the reference object is outside this radius, the
		 * volume will be outerRadiusVolume. When the reference object is inside the radius, the
		 * volume will be linearly scaled up to 100% volume until the inner radius. The outer
		 * radius can't be set smaller than the inner radius
		 */
		public function get outerRadius():Number { return this.m_outerRadius; }
		public function set outerRadius( n:Number ):void
		{
			this.m_outerRadius 	= ( n < this.m_innerRadius ) ? this.m_innerRadius : n;
			this.m_isDirty		= true;
		}
		
		/**
		 * The inner angle for the sound, from 0.0 to 360.0. This angle is for the inner
		 * radius, and controls the sound at 100% volume. If the innerAngle is 360.0, then it
		 * will be clearly heard from all angles, otherwise, you can combine this with the
		 * rotation to enable the sound from specific directions. If the inner angle is set to be
		 * larger than the outer angle, the outer angle will be increased to match
		 */
		public function get innerAngle():Number { return this.m_innerAngle; }
		public function set innerAngle( n:Number ):void
		{
			this.m_innerAngle 	= ( n < 0.0 ) ? 0.0 : ( n > 360.0 ) ? 360.0 : n;
			this.m_isDirty		= true;
			if ( this.m_innerAngle > this.m_outerAngle )
				this.outerAngle = this.m_innerAngle;
		}
		
		/**
		 * The outer angle for the sound, from 0.0 to 360.0. This angle is for the outer
		 * radius, and controls the sound from outerRadiusVolume to 100% volume. The outer
		 * angle can't be set smaller than the inner angle
		 */
		public function get outerAngle():Number { return this.m_outerAngle; }
		public function set outerAngle( n:Number ):void
		{
			this.m_outerAngle 	= ( n < this.m_innerAngle ) ? this.m_innerAngle : ( n > 360.0 ) ? 360.0 : n;
			this.m_isDirty		= true;
		}
		
		/**
		 * The volume for the sound at 100%, or when our reference obj/pos is inside the 
		 * inner cone. If it's set lower than the outerRadiusVolume, the outerRadiusVolume
		 * is decreased to match
		 */
		public function get volume():Number { return this.m_volume; }
		public function set volume( n:Number ):void
		{
			this.m_volume 	= ( n < 0.0 ) ? 0.0 : ( n > 1.0 ) ? 1.0 : n;
			this.m_isDirty	= true;
			if ( this.m_outerRadiusVolume > this.m_volume )
				this.outerRadiusVolume = this.m_volume;
			if ( this.m_volume < this.m_currVolume )
				this.m_currVolume = this.m_volume;
		}
		
		/**
		 * The current volume of the positional sound, which will be between outerRadiusVolume
		 * and volume, depending on the position of the reference obj/pos to the sound. This 
		 * takes into account the fadeVolume
		 */
		public function get currVolume():Number { return this.m_currVolume * this.m_fadeVolume; }
		
		/**
		 * The volume of the sound when our refObj or refPos is outside the outerRadius. If 0.0,
		 * then the sound will be stopped and will continue to "play" in memory, allowing you to have
		 * more than the max 32 sounds playing at once, assuming not all sounds overlap. It can't
		 * be set higher than volume
		 */
		public function get outerRadiusVolume():Number { return this.m_outerRadiusVolume; }
		public function set outerRadiusVolume( n:Number ):void
		{
			this.m_outerRadiusVolume 	= ( n < 0.0 ) ? 0.0 : ( n > this.m_volume ) ? this.m_volume : n;
			this.m_isDirty				= true;
			if ( this.m_outerRadiusVolume > this.m_currVolume )
				this.m_currVolume = this.m_outerRadiusVolume;
		}
		
		/**
		 * The fade volume of the sound, if we want to control the global level while leaving the max
		 * volume etc as it is (e.g. fade in the sound, have a global sound level)
		 */
		public function get fadeVolume():Number { return this.m_fadeVolume; }
		public function set fadeVolume( n:Number ):void
		{
			this.m_fadeVolume 	= ( n < 0.0 ) ? 0.0 : ( n > 1.0 ) ? 1.0 : n;
			this.m_isDirty		= true;
		}
		
		/**
		 * The type that describes how to deal with pan for this sound. See the
		 * PositionalSoundPanType for more information
		 */
		public function get panType():PositionalSoundPanType { return this.m_panType; }
		public function set panType( p:PositionalSoundPanType ):void
		{
			this.m_panType 	= ( p == null ) ? PositionalSoundPanType.NONE : p;
			this.m_isDirty	= true;
			if ( this.m_panType == PositionalSoundPanType.NONE ) // if it's none, make sure our pan is centered
				this.m_currPan = 0.0;
		}
		
		/**
		 * The maximum pan we can have in either channel for this sound, from 0.0 to 1.0. A
		 * value of 0.0 means that the sound will never be panned, while a value of 1.0 means
		 * that it's possible to get the sound entirely in one channel
		 */
		public function get maxPan():Number { return this.m_maxPan; }
		public function set maxPan( n:Number ):void
		{
			this.m_maxPan 	= ( n < 0.0 ) ? 0.0 : ( n > 1.0 ) ? 1.0 : n;
			this.m_isDirty	= true;
			if ( this.m_currPan > this.m_maxPan )
				this.m_currPan = this.m_maxPan;
			else if ( this.m_currPan < -this.m_maxPan )
				this.m_currPan = -this.m_maxPan;
		}
		
		/**
		 * When using positional volume, and if we have a reference object, the volume will dip
		 * a little based on if it's behind us or not (mimics how human ears work because of their
		 * shape). This is the limit where we decide an object is "behind" us, from 0.0 to 1.0,
		 * 0.0 being that the sound is to the reference object's right or left, 1.0 being that the
		 * sound is directly behind it. Set to 1.0 to ignore this
		 */
		public function get positionalVolBehindLimit():Number { return this.m_posVolLimit; }
		public function set positionalVolBehindLimit( n:Number ):void
		{
			this.m_posVolLimit 	= ( n < 0.0 ) ? 0.0 : ( n > 1.0 ) ? 1.0 : n;
			this.m_isDirty		= true;
		}
		
		/**
		 * When using positional volume, and if we have a reference object, if the sound is behind
		 * us, this is the multiplier applied, from 0.0 to 1.0, 0.0 being we don't hear the sound at
		 * all, 1.0 being that the sound isn't affected. The multiplier is for when the sound is
		 * directly behind our object; the actual value is adjusted depending on the how much the
		 * sound is behind our object, as well as how close our object is to the sound source (closer =
		 * this effect is applied less)
		 */
		public function get positionalVolBehindMult():Number { return this.m_posVolMult; }
		public function set positionalVolBehindMult( n:Number ):void
		{
			this.m_posVolMult 	= ( n < 0.0 ) ? 0.0 : ( n > 1.0 ) ? 1.0 : n;
			this.m_isDirty		= true;
		}
		
		/**
		 * When the sound is playing, this is the current position in milliseconds
		 */
		public function get position():Number { return this.m_position; }
		
		/**
		 * Is the sound paused?
		 */
		public function get isPaused():Boolean { return this.m_isPaused; }
		
		/**
		 * Is the sound currently playing, and not paused?
		 */
		public function get isPlaying():Boolean { return ( this.m_isPlaying || ( this.m_channel != null ) ) };
		
		/**
		 * A clipping rectangle to apply to the sound. If our reference object/point is outside this
		 * rect, then no sound will be heard. This can be used, for example, to limit sounds to rooms.
		 * The clipRect is relative to the position. Use clipRectRotation to rotate the clipRect around
		 * the position
		 */
		public function get clipRect():Rectangle { return this.m_clipRect; }
		public function set clipRect( r:Rectangle ):void
		{
			this.m_clipRect = r;
			this.m_isDirty	= true;
		}
		
		/**
		 * The rotation of the clipRect, in degrees. 0.0 to 180.0 represents clockwise
		 * rotation, while 0.0 to -180.0 represents counter-clockwise rotation. Values
		 * will be limited to -180.0/180.0 range
		 */
		public function get clipRectRotation():Number { return this.m_clipRectRotation; }
		public function set clipRectRotation( n:Number ):void
		{
			this.m_clipRectRotation = n;
			this.m_isDirty			= true;
			
			// clamp between -180 and 180
			while ( this.m_clipRectRotation < -180.0 )
				this.m_clipRectRotation += 360.0;
			while ( this.m_clipRectRotation > 180.0 )
				this.m_clipRectRotation -= 360.0;
				
			// get our rotation in radians
			this.m_clipRectRotationRads = MathHelper.degreesToRadians( this.m_clipRectRotation );
		}
		
		/**
		 * Is the clipRect inversed? If true, then sound will be clipped when our ref obj/pos
		 * is inside the rect, and audible from the outside
		 */
		public function get isClipRectInversed():Boolean { return this.m_isClipRectInversed; }
		public function set isClipRectInversed( b:Boolean ):void
		{
			this.m_isClipRectInversed 	= b;
			this.m_isDirty				= true;
		}
		
		/********************************************************************************/
		
		/**
		 * Creates a new PositionalSound object
		 * @param sound An optional Sound object to control
		 */
		public function PositionalSound( sound:Sound = null ) 
		{
			// set some initial vars
			// NOTE: go through the setters
			this.sound						= sound;
			this.pos						= new Point;
			this.m_prevPos					= new Point;
			this.m_prevRefPos				= new Point;
			this.innerAngle					= 360.0;
			this.outerAngle					= 360.0;
			this.innerRadius				= 100.0;
			this.outerRadius				= 200.0;
			this.volume						= 1.0;
			this.m_currVolume				= 0.0;
			this.outerRadiusVolume			= 0.0;
			this.fadeVolume					= 1.0;
			this.panType					= PositionalSoundPanType.NONE;
			this.maxPan						= 1.0;
			this.positionalVolBehindLimit	= 0.8;
			this.positionalVolBehindMult	= 0.8;
			this.m_transform				= new SoundTransform( this.m_volume, this.m_currPan );
		}
		
		/**
		 * Destroys the PositionalSound and clears it for garbage collection
		 */
		public function destroy():void
		{
			// if we have a channel, kill it
			if ( this.m_channel != null )
				this.stop();
				
			// null our references
			this.m_sound		= null;
			this.m_pos			= null;
			this.m_prevPos		= null;
			this.m_followObj	= null;
			this.m_refObj		= null;
			this.m_refPos		= null;
			this.m_prevRefPos	= null;
			this.m_clipRect		= null;
			this.m_panType		= null;
			this.m_transform	= null;
			this.m_channel		= null;
		}
		
		/**
		 * Sets the angles used for the positional sound, which will define the inner
		 * and outer cones. The values range from 0.0 to 360.0, with 360.0 equalling
		 * full range. Values under 360.0 can, combined with the rotation property,
		 * provide a directional sound
		 * @param inner The angle for the inner cone, where sound is at 100% volume
		 * @param outer The angle for the outer cone, where sound will be linearly scaled from outerRadiusVolume to 100%
		 */
		public function setAngles( inner:Number, outer:Number ):void
		{
			this.innerAngle = inner;
			this.outerAngle = outer;
		}
		
		/**
		 * Sets the radii used for the positional sound, for the range of the inner
		 * and outer cones
		 * @param inner The radius for the inner cone, where sound is at 100% volume
		 * @param outer The radius for the outer cone, where sound will be linearly scaled from outerRadiusVolume to 100%
		 */
		public function setRadii( inner:Number, outer:Number ):void
		{
			this.innerRadius = inner;
			this.outerRadius = outer;
		}
		
		/**
		 * Sets the volumes used for the positional sound
		 * @param max The max volume for the sound, which we'll have if the reference object/pos is inside
		 * the inner cone
		 * @param outer The volume that we'll have when the reference object/pos is outside
		 * the outer cone
		 * @param fade A fade volume level, used to set a global volume level, or to fade the sound while
		 * leaving the max and outer untouched
		 */
		public function setVolumes( max:Number, outer:Number, fade:Number = 1.0 ):void
		{
			this.volume 			= max;
			this.outerRadiusVolume	= outer;
			this.m_currVolume		= this.m_outerRadiusVolume;
			this.fadeVolume			= fade;
		}
		
		/**
		 * Starts loading an external MP3 file from the specified URL. If we don't have a Sound
		 * already set, a new one is created. Once load() is called, you can't load a different
		 * sound file unless you set a new Sound property, or clear the current one to null.
		 * All potential errors that can be thrown will be caught
		 * @param stream A URL that points to an external MP3 file.
		 * @param context An optional SoundLoader context object, which can define the buffer time 
		 * (the minimum number of milliseconds of MP3 data to hold in the Sound object's buffer) 
		 * and can specify whether the application should check for a cross-domain policy file 
		 * prior to loading the sound.
		 */
		public function load( stream:URLRequest, context:SoundLoaderContext = null ):void
		{
			// if we don't have a sound, create one
			this.m_sound ||= new Sound;
			try { this.m_sound.load( stream, context ); }
			catch ( e:Error )
			{
				// generic catch-all error
				trace( "3:Error when trying to load sound from " + stream + ". " + e.errorID + ": " + e.name + ": " + e.message );
			}
		}
		
		/**
		 * Starts playing the sound. We make an initial check for the relative volume and pan and we'll
		 * only actually start playing the sound if the volume is > 0.0 or shouldClearZeroVolumeSounds
		 * is set to false, otherwise, we'll "play" in memory. If we're already playing a sound, nothing
		 * happens
		 * @param startTime	The initial position in milliseconds at which playback should start.
		 * @param loops	Defines the number of times a sound loops back to the startTime value
		 *   before the sound channel stops playback. NOTE: In Sound, a value of 1 would play the sound
		 *   exactly *once*, rather than playing once, then looping once. PositionalSound corrects this
		 */
		public function play( startTime:Number = 0, loops:int = 0 ):void 
		{
			// we need a sound to play
			if ( this.m_sound == null )
			{
				trace( "2:Can't play the PositionalSound as there's no Sound object set. Either do it in the constructor, or use the setter" );
				return;
			}
			
			// if we're already playing, do nothing, as we only control one channel at a time
			if ( this.m_isPlaying )
			{
				trace( "2:The PositionalSound is already playing! Either wait for it to finish, or create a new one" );
				return;
			}
			
			// check our initial volume and pan
			this._updateVolumeAndPan();
			
			// start playing the sound
			this.m_startTime	= startTime;
			this.m_position		= this.m_startTime;
			this.m_loops		= loops + 1;
			this._playSound( this.m_loops );
		}
		
		/**
		 * Pauses playback to the sound. Use resume to continue playback from the same position
		 */
		public function pause():void
		{
			// if we're not playing, do nothing
			if ( !this.m_isPlaying )
				return;
				
			// stop it and store our values
			if( this.m_channel != null )
				this.m_position = this.m_channel.position;
			this.stop();
			this.m_isPaused	= true;
		}
		
		/**
		 * Resumes the sound if we've been paused
		 */
		public function resume():void
		{
			this._playSound( 1 );
		}
		
		/**
		 * Stops playing the sound
		 */
		public function stop():void
		{
			this._onSoundStopped( null, true );
		}
		
		/**
		 * Updates the PositionalSound. Call this every frame so the volume and pan can be
		 * adjusted based on the reference object/position, we can update our sound's position
		 * if necessary, and we can keep track of our current position for playback
		 * @param dt The delta time since the last call to update()
		 */
		public function update( dt:Number ):void
		{
			// if we're following an object, update our position
			if ( this.m_followObj != null )
				this.m_pos.setTo( this.m_followObj.x, this.m_followObj.y );
				
			// if we're not playing, just return
			if ( !this.m_isPlaying )
				return;
				
			// track our channel position and loops
			if ( this.m_channel != null )
			{
				// keep track of if we looped or not, in case we call pause() and resume()
				if ( this.m_channel.position < this.m_position )
					this.m_loops = ( this.m_loops > 0 ) ? this.m_loops - 1 : 0; // we've looped
				
				// hold the current position of the channel
				this.m_position = this.m_channel.position;
			}
			else
			{
				this.m_position += dt * 1000; // position is in millis, while dt is in seconds
				if ( this.m_position >= this.m_sound.length && this.m_sound.length > 0 )
				{
					this.m_loops 	= ( this.m_loops > 0 ) ? this.m_loops - 1 : 0;
					this.m_position -= this.m_sound.length;
					if ( this.m_loops == 0 )
					{
						// our sound is finished
						this._onSoundStopped( null, true );
						return;
					}
				}
			}
			
			// update our volume and pan
			var shouldUpdate:Boolean 	= this._shouldUpdate();
			this.m_isDirty				= false;
			if ( shouldUpdate )
				this._updateVolumeAndPan();
			else
			{
				// we don't need to update - so if we're not going to change much (we're doing a lerp
				// to the final values), then just quit
				var diffVol:Number 	= this.m_currVolume - this.m_transform.volume;
				var diffPan:Number	= this.m_currPan - this.m_transform.pan;
				if ( diffVol < 0.01 && diffVol > -0.01 && diffPan < 0.01 && diffPan > -0.01 )
					return;
			}
			
			// if our volume is 0.0, then we can kill the channel (we'll still "play" in memory)
			var finalVol:Number = this.m_currVolume * this.m_fadeVolume;
			finalVol 			= MathHelper.lerp( this.m_transform.volume, finalVol, 0.4 );
			finalVol			= ( finalVol < this.m_outerRadiusVolume + 0.01 ) ? this.m_outerRadiusVolume : ( finalVol > this.m_volume - 0.01 ) ? this.m_volume : finalVol;
			if ( finalVol == 0.0 && this.m_channel != null && PositionalSound.shouldClearZeroVolumeSounds )
				this._killChannel();
			else if ( finalVol > 0.0 && this.m_channel == null )
				this._playSound( 1 );
			
			// if we don't have a channel, we don't need to go any further
			if ( this.m_channel == null )
				return;
			
			// we only need to apply them if the values have changed
			if ( this.m_transform.volume != finalVol || 
				 this.m_transform.pan != this.m_currPan )
			{
				this.m_transform.volume			= finalVol;
				this.m_transform.pan			= this.m_currPan;
				this.m_channel.soundTransform	= this.m_transform;
			}
		}
		
		/**
		 * Draws some debug graphics to help position the sound
		 * @param graphics The graphics object that we're going to draw into. Assumes that it's in
		 * the same relative coordinate space
		 * @param shouldClear Should we clear the graphics before starting?
		 */
		public function drawDebug( graphics:Graphics, shouldClear:Boolean = true ):void
		{
			if ( shouldClear )
				graphics.clear();
				
			// draw our position first
			graphics.lineStyle( 1.0, 0x990000 );
			graphics.drawCircle( this.m_pos.x, this.m_pos.y, 3.0 );
				
			// showing rotation
			graphics.moveTo( this.m_pos.x, this.m_pos.y );
			graphics.lineTo( this.m_pos.x + Math.cos( this.m_rotationRads ) * this.m_outerRadius, this.m_pos.y + Math.sin( this.m_rotationRads ) * this.m_outerRadius );
			
			// inner radius
			graphics.lineStyle( 1.0, 0x009900 );
			if ( this.m_innerAngle == 360.0 )
				graphics.drawCircle( this.m_pos.x, this.m_pos.y, this.m_innerRadius );
			else
				this._drawCone( graphics, this.m_innerAngle, this.m_innerRadius );
				
			// outer radius
			graphics.lineStyle( 1.0, 0x000099 );
			if ( this.m_outerAngle == 360.0 )
				graphics.drawCircle( this.m_pos.x, this.m_pos.y, this.m_outerRadius );
			else
				this._drawCone( graphics, this.m_outerAngle, this.m_outerRadius );
				
			// clip rect
			if ( this.m_clipRect != null )
			{
				graphics.lineStyle( 1.0, 0x999999 );
				
				// axis aligned
				var dirLen:Number = ( this.m_isClipRectInversed ) ? -5.0 : 5.0; // for drawing clipRect dir
				if ( this.m_clipRectRotation == 0.0 )
				{
					var x:Number = this.m_pos.x + this.m_clipRect.x;
					var y:Number = this.m_pos.y + this.m_clipRect.y;
					
					// our clip rect
					graphics.drawRect( x, y, this.m_clipRect.width, this.m_clipRect.height );
					
					// clip rect dir (on right) - shows if it's inversed or not
					graphics.moveTo( x + this.m_clipRect.width, y + this.m_clipRect.height * 0.5 );
					graphics.lineTo( x + this.m_clipRect.width - dirLen, y + this.m_clipRect.height * 0.5 );
				}
				else
				{
					// tl
					var p:Point = PositionalSound.m_helperPoint;
					p.setTo( this.m_clipRect.x, this.m_clipRect.y );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.moveTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
					var tlx:Number = p.x;
					var tly:Number = p.y;
					
					// tr
					p.setTo( this.m_clipRect.x + this.m_clipRect.width, this.m_clipRect.y );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.lineTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
					
					// br
					p.setTo( this.m_clipRect.x + this.m_clipRect.width, this.m_clipRect.y + this.m_clipRect.height );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.lineTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
					
					// bl
					p.setTo( this.m_clipRect.x, this.m_clipRect.y + this.m_clipRect.height );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.lineTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
					graphics.lineTo( this.m_pos.x + tlx, this.m_pos.y + tly );
					
					// clip rect dir (on right) - shows if it's inversed or not
					p.setTo( this.m_clipRect.x + this.m_clipRect.width, this.m_clipRect.y + this.m_clipRect.height * 0.5 );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.moveTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
					p.setTo( this.m_clipRect.x + this.m_clipRect.width - dirLen, this.m_clipRect.y + this.m_clipRect.height * 0.5 );
					MathHelper.rotate( p, this.m_clipRectRotationRads, p );
					graphics.lineTo( this.m_pos.x + p.x, this.m_pos.y + p.y );
				}
			}
				
			// we need a reference object or position after this point
			if ( this.m_refObj == null && this.m_refPos == null )
				return;
			
			// to the reference position
			var rx:Number = ( this.m_refObj != null ) ? this.m_refObj.x : this.m_refPos.x;
			var ry:Number = ( this.m_refObj != null ) ? this.m_refObj.y : this.m_refPos.y;
			graphics.lineStyle( 1.0, 0x990099 );
			graphics.moveTo( this.m_pos.x, this.m_pos.y );
			graphics.lineTo( rx, ry );
		}
		
		/********************************************************************************/
		
		// checks if we need to update - if something is dirty, or our positions have changed
		private function _shouldUpdate():Boolean
		{
			// get our reference positions: NOTE: they could both be null
			var rx:Number = ( this.m_refObj != null ) ? this.m_refObj.x : ( this.m_refPos != null ) ? this.m_refPos.x : NaN;
			var ry:Number = ( this.m_refObj != null ) ? this.m_refObj.y : ( this.m_refPos != null ) ? this.m_refPos.y : NaN;
			var rr:Number = ( this.m_refObj != null ) ? this.m_refObj.rotation : 0.0;
			
			// if we're dirty, or if our position has changed, then yes
			if ( this.m_isDirty || this.m_prevPos.x != this.pos.x || this.m_prevPos.y != this.m_pos.y )
			{
				// make sure our prev positions are up to date
				this.m_prevPos.setTo( this.pos.x, this.m_pos.y );
				this.m_prevRefPos.setTo( rx, ry );
				this.m_prevRefObjRotation = rr;
				return true;
			}
			
			// if our reference position has changed, then yes
			var isRefPosNaN:Boolean		= ( rx != rx ); // quick nan check
			var isPrevRefPosNaN:Boolean	= ( this.m_prevRefPos.x != this.m_prevRefPos.x );
			if ( isRefPosNaN != isPrevRefPosNaN || this.m_prevRefPos.x != rx || this.m_prevRefPos.y != ry )
			{
				// make sure our prev positions are up to date
				this.m_prevRefPos.setTo( rx, ry );
				this.m_prevRefObjRotation = rr;
				return true;
			}
			
			// if we have a reference object, and our pan type is REFERENCE, or we're using positional
			// volume, then yes
			if ( this.m_refObj != null )
			{
				if ( ( 	this.m_panType == PositionalSoundPanType.REFERENCE ||
						this.m_posVolLimit < 1.0 ||
						this.m_posVolMult < 10 ) && this.m_refObj.rotation != this.m_prevRefObjRotation )
				{
					this.m_prevRefObjRotation = rr;
					return true;
				}
			}
			
			// nothing has changed since the last update, so we don't need to process
			// any change in volume or pan
			return false;
		}
		
		// plays our sound
		private function _playSound( loops:uint ):void
		{
			// we're already playing, so do nothing
			if ( this.m_channel != null )
				return;
				
			// update our transform
			this.m_transform.volume = ( this.m_currVolume * this.m_fadeVolume );
			this.m_transform.pan	= this.m_currPan;
				
			// start playing (if our volume is > 0.0 and we're not clearing zero volume sounds)
			if ( this.m_transform.volume > 0.0 || !PositionalSound.shouldClearZeroVolumeSounds )
			{
				// NOTE: it's possible that this is null (maxed sound channels etc)
				this.m_channel = this.m_sound.play( this.m_position, loops, this.m_transform );
				if ( this.m_channel != null )
				{
					this.m_position	= this.m_channel.position; // to stop the loop check in update firing
					this.m_channel.addEventListener( Event.SOUND_COMPLETE, this._onSoundStopped );
				}
			}
			
			// if the channel is null, technically, we can start "playing" in memory
			this.m_isPaused		= false;
			this.m_isPlaying	= true;
		}
		
		// updates the volume (normal and positional) and the pan for the sound. this is only
		// called if we're currently playing a sound
		private function _updateVolumeAndPan():void
		{
			// if both our refObj and refPos are null, just return
			if ( this.m_refObj == null && this.m_refPos == null )
			{
				this.m_currVolume 	= 0.0;
				this.m_currPan		= 0.0;
				return;
			}
				
			// get our reference position
			var rx:Number = ( this.m_refObj != null ) ? this.m_refObj.x : this.m_refPos.x;
			var ry:Number = ( this.m_refObj != null ) ? this.m_refObj.y : this.m_refPos.y;
			
			// if we have a clip rect, check it
			if ( this.m_clipRect != null && this._checkClipRect( rx, ry ) )
				return;
			
			// some quick checks to return straight away
			if ( this.m_outerRadius == 0.0 || this.m_outerAngle == 0.0 )
			{
				this.m_currVolume 	= this.m_outerRadiusVolume;
				this.m_currPan		= 0.0;
				return;
			}
				
			// get the vector to our reference position
			var dx:Number = rx - this.m_pos.x;
			var dy:Number = ry - this.m_pos.y;
			
			// update our volume and pan
			this._updateVolume( dx, dy );
			this._updatePositionalVolume( dx, dy );
			this._updatePan( dx, dy );
		}
		
		// updates the volume for the sound, based on where our reference is and our cones
		private function _updateVolume( dx:Number, dy:Number ):void
		{
			// get the dist to our reference
			var or2:Number 	= this.m_outerRadius * this.m_outerRadius; // outer radius squared
			var dist:Number	= ( dx * dx ) + ( dy * dy );
			if ( dist > or2 )
			{
				// we're outside the max radius, so just set to the outer radius volume
				this.m_currVolume = this.m_outerRadiusVolume;
				return;
			}
			
			// we're inside the outer radius, so we need to check if we're inside the outer, or
			// inner cones (if we have cones). first check if both our outer and inner radii are
			// full circles, as then the calculation is easier
			var ir2:Number 	= this.m_innerRadius * this.m_innerRadius; // inner radius squared
			var pc:Number	= 0.0;
			if ( this.m_outerAngle == 360.0 && this.m_innerAngle == 360.0 )
			{
				// both our outer and inner are circles, so we can just return a simple radius mult
				if ( dist <= ir2 )
				{
					// we're inside the inner circle, so full volume
					this.m_currVolume = this.m_volume;
					return;
				}
				
				// we're between the inner and outer circles, so scale linearly
				pc					= 1.0 - ( ( dist - ir2 ) / ( or2 - ir2 ) );
				this.m_currVolume 	= this.m_outerRadiusVolume + ( this.m_volume - this.m_outerRadiusVolume ) * pc;
				return;
			}
			
			// we have either an outer cone, an inner cone, or both.
			// get the reference point relative to us, unrotated
			var hp:Point = PositionalSound.m_helperPoint;
			hp.setTo( dx, dy );
			MathHelper.rotate( hp, -this.m_rotationRads, hp ); // remove our sound rotation
			
			// get the angle, and check is it within our different bounds
			// NOTE: when comparing angles it needs to be positive (as our inner/outer angles are between
			// 0.0 and 360.0) and doubled (as an inner/outer angle of 90o is 45o on either side of
			// the sound rotation, so when our reference angle is 45o in relation to the sound, that's
			// on the limit of a 90o cone)
			var angle:Number 			= MathHelper.degreeAngle( hp.x, hp.y );
			angle						*= ( angle < 0.0 ) ? -2.0 : 2.0; 	// get our angle in the same space as inner and outer
			var isInsideOuter:Boolean 	= ( angle <= this.m_outerAngle );	// are we inside the outer cone?
			var isInsideInner:Boolean 	= ( angle <= this.m_innerAngle );	// are we inside the inner cone?
			
			// if we're outside the outer cone, just return the outer radius volume
			if ( !isInsideOuter )
			{
				this.m_currVolume = this.m_outerRadiusVolume;
				return;
			}
			
			// if we're inside the inner cone, and inside the inner radius, return 100%
			if ( isInsideInner && dist <= ir2 )
			{
				this.m_currVolume = this.m_volume;
				return;
			}
			
			// we're between the inner and the outer cone, so find our volume percentage based on how
			// close we are to the inner angle, and how close we are to the inner radius
			var rPC:Number 			= 1.0 - ( ( Math.sqrt( dist ) - this.m_innerRadius ) / ( this.m_outerRadius - this.m_innerRadius ) );	// radius %
			var aPC:Number			= 1.0 - ( ( angle - this.m_innerAngle ) / ( this.m_outerAngle - this.m_innerAngle ) );					// angle %
			if ( aPC > 1.0 ) aPC 	= 1.0; 	// we're smaller than the inner angle, so clamp
			if ( rPC > 1.0 ) rPC 	= 1.0;	// we're smaller tha the inner radius, so clamp
			pc						= rPC * aPC;
			this.m_currVolume 		= this.m_outerRadiusVolume + ( this.m_volume - this.m_outerRadiusVolume ) * pc;
		}
		
		// positional volume is only if we have a reference object. basically we lower
		// the volume if the sound is behind our object, similar to what happens with our
		// hearing because of the shape of our ear
		private function _updatePositionalVolume( dx:Number, dy:Number ):void
		{
			// we only care about this if we have a reference object (as we need its rotation)
			if ( this.m_refObj == null || this.m_posVolMult >= 1.0 || this.m_posVolLimit >= 1.0 )
				return;
				
			// hold the distance (squared)
			var dist:Number = ( dx * dx ) + ( dy * dy );
				
			// get the dot with the ref object's rotation
			PositionalSound.m_helperPoint.setTo( dx, dy );
			PositionalSound.m_helperPoint.normalize( 1.0 );
			var rotRads:Number 	= MathHelper.degreesToRadians( this.m_refObj.rotation ); // -90 so we get the refObj's "up"
			var dot:Number		= MathHelper.dot( PositionalSound.m_helperPoint.x, PositionalSound.m_helperPoint.y, Math.cos( rotRads ), Math.sin( rotRads ) );	
			if ( dot < this.m_posVolLimit )
				return;
				
			// we're going to affect the sound, so also diminish the behind effect based on how close we are
			var ir2:Number		= this.m_innerRadius * this.m_innerRadius;
			var closePC:Number 	= ( dist >= ir2 ) ? 1.0 : ( ir2 == 0.0 ) ? 0.0 : ( dist / ir2 );
				
			// get our pc and update our volume
			var behindPC:Number = 1.0 - ( dot - this.m_posVolMult ) * closePC;
			this.m_currVolume	*= behindPC;
		}
		
		// updates the pan for the sound depending on our panType
		private function _updatePan( dx:Number, dy:Number ):void
		{
			// no pan type, or our volume is 0.0, then keep the current pan
			if ( this.m_panType == PositionalSoundPanType.NONE || ( this.m_currVolume  * this.m_fadeVolume ) == 0.0 )
				return;
			
			// get the vector to the player (if we're close enough to it, just center the pan)
			PositionalSound.m_helperPoint.setTo( dx, dy );
			if ( PositionalSound.m_helperPoint.length <= 1.0 )
			{
				this.m_currPan = 0.0;
				return;
			}
			PositionalSound.m_helperPoint.normalize( 1.0 );
				
			// if it's the PLAYER type, or our reference object is a point (where we have no
			// orientation data), then return the pan relative to the player position
			var dot:Number = 0.0;
			if ( this.m_panType == PositionalSoundPanType.PLAYER || this.m_refObj == null )
			{
				// get our vector to the ref position - as this is for the player, we don't
				// care about the rotation of the sound, so we can just use the left vector for it.
				// NOTE: we use left rather than right, as when our object is on the left of the sound, we
				// want it to be panned right, so we can either use left, or use right and invert it
				dot = MathHelper.dot( PositionalSound.m_helperPoint.x, PositionalSound.m_helperPoint.y, -1.0, 0.0 );
			}
			else
			{
				// we're getting the pan relative to the reference object, meaning that if it's on their
				// left, we pan left, if it's on the right, we pan right
				var rotRads:Number 	= MathHelper.degreesToRadians( this.m_refObj.rotation - 90 ); // -90 so we get the refObj's "up"
				dot 				= MathHelper.dot( PositionalSound.m_helperPoint.x, PositionalSound.m_helperPoint.y, Math.cos( rotRads ), Math.sin( rotRads ) );	
			}
			this.m_currPan = ( this.m_maxPan * dot );
		}
		
		// checks if our ref object/pos is outside our clip rect, and if so, clears the sound
		private function _checkClipRect( rx:Number, ry:Number ):Boolean
		{
			// if our rect isn't axis-aligned, then rotate the point in the opposite
			// direction, around our position
			if ( this.m_clipRectRotation != 0.0 )
			{
				PositionalSound.m_helperPoint.setTo( rx - this.m_pos.x, ry - this.m_pos.y );
				MathHelper.rotate( PositionalSound.m_helperPoint, -this.m_clipRectRotationRads, PositionalSound.m_helperPoint );
				rx = this.m_pos.x + PositionalSound.m_helperPoint.x;
				ry = this.m_pos.y + PositionalSound.m_helperPoint.y;
			}
			
			// check if the point is outside our clipRect
			var isOutside:Boolean = ( rx < this.m_pos.x + this.m_clipRect.x ||
									  rx > this.m_pos.x + this.m_clipRect.x + this.m_clipRect.width ||
									  ry < this.m_pos.y + this.m_clipRect.y ||
									  ry > this.m_pos.y + this.m_clipRect.y + this.m_clipRect.height )
									  
			// if we're outside and our clip rect is normal, or we're inside and our
			// clip rect is inversed, kill the sound
			if( ( isOutside && !this.m_isClipRectInversed ) || ( !isOutside && this.m_isClipRectInversed ) )
			{
				this.m_currVolume 	= 0.0;
				this.m_currPan		= 0.0;
				return true;
			}
			return false;
		}
		
		// called when our sound has looped - check if we need to play it again, or stop it altogether
		private function _onSoundLooped():void
		{
			this.m_loops--;
			if ( this.m_loops >= 0 )
			{
				// update our position
				this.m_position = this.m_startTime;
				this._playSound( 1 );
			}
		}
		
		// called when our sound has stopped
		private function _onSoundStopped( e:Event = null, fromStop:Boolean = false ):void
		{
			this._killChannel();
			this.m_isPlaying	= false;
			this.m_isPaused		= false;
			
			// we get here 2 ways; either we call stop() ourselves, or as a result of a resume (when
			// we resume, we start a our previous position, but it means that we have to control the
			// looping ourselves, as flash will by default, loop to the position passed in the play()
			// method, so to loop we play once, the play again, etc)
			if ( !fromStop && this.m_loops > 1 ) // our loops will be 1 when this is the last play
				this._onSoundLooped();
		}
		
		// kills our channel and stops it from playing
		private function _killChannel():void
		{
			if ( this.m_channel == null )
				return;
			this.m_channel.removeEventListener( Event.SOUND_COMPLETE, this._onSoundStopped );
			this.m_channel.stop();
			this.m_channel = null; // if we call play/resume again, we get a new channel
		}
		
		// draws an cone of a given angle to a given radius
		private function _drawCone( graphics:Graphics, angle:Number, radius:Number ):void
		{
			// get our angle in radians, and half it
			var hr:Number = MathHelper.degreesToRadians( angle ) * 0.5;
			
			// we're going to rotate a point, so create the point to the size of our radius
			var p:Point 	= PositionalSound.m_helperPoint;
			var rp:Point 	= PositionalSound.m_helperPoint; // our rotated point
			p.setTo( radius, 0.0 ); // facing right
			
			// we're going to draw our cone in blocks of 10 degrees
			var iters:int 		= int( angle / 10 );
			var rIters:Number	= ( iters > 0 ) ? ( hr * 2.0 ) / iters : 0.0;	// how much we're increasing each iteration
			var cr:Number		= this.m_rotationRads - hr; 					// our current radians
			
			// draw our cone
			graphics.moveTo( this.m_pos.x, this.m_pos.y );
			for ( var i:int = 0; i <= iters; i++ )
			{
				p.setTo( radius, 0.0 );
				MathHelper.rotate( p, cr, rp );
				graphics.lineTo( this.m_pos.x + rp.x, this.m_pos.y + rp.y );
				cr += rIters;
			}
			
			// draw our finish
			p.setTo( radius, 0.0 );
			MathHelper.rotate( p, this.m_rotationRads + hr, rp );
			graphics.lineTo( this.m_pos.x + rp.x, this.m_pos.y + rp.y );
			graphics.lineTo( this.m_pos.x, this.m_pos.y );
		}
		
	}

}