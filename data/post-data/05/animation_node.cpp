

struct Transition
{
  bool can_interrupt;
};

  // 'AnimationID' is just anything you want.
  // We used an enum but strings work as well.
  //
  // The Key in this may is what animation we can transition too.
  // The Value is a glorified 'bool' that holds whether or not this
  // transition can interrupt the current animation.
using TransitionMap = std::unordered_map<AnimationID, Transition>;

struct AnimationNode
{
  Animation     anim;        // Whatever an animation is in your engine (we basically used an enum).
  TransitionMap transitions; // Who this animation can go to.
};

