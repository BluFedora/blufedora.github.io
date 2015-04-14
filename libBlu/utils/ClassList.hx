package libBlu.utils;

#if macro
	import haxe.macro.Context.*;
	using haxe.macro.Tools;
#end

/**
 * Macro Class do get Class Names
 * @author Shareef Raheem (Blufedora)
 */
class ClassList 
{
	private static var NAME = 'libBlu.utils.ClassList ';//must be the fully qualified name of this class
	
	macro static function build() 
	{
		onGenerate(function (types) 
		{
			var names = [],
			self = getType(NAME).getClass();
			for (t in types)
			switch t 
			{
				case TInst(_.get() => c, _):
				names.push(makeExpr(c.name, c.pos));
				default:
			}
			
			self.meta.remove('classes');
			self.meta.add('classes', names, self.pos);
		});
		
		return macro cast haxe.rtti.Meta.getType($p{NAME.split('.')});
	}

	#if !macro
		public static var ALL_NAMES(default, null):Array<String> = build();
	#end
}
//* USAGE: *//
//trace(ClassList.ALL_NAMES);