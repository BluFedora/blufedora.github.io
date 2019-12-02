

using AnimationMap = std::unordered_map<AnimationID, Transition>;

class Animator
{
  private:
    AnimationMap m_Roots;                  // Animation nodes
    AnimationID  m_CurrentAnimation;       // Currently playing animation.
    Transition   m_CurrentTransition;      // The currently
    AnimationID  m_NextAnimation;          // The queued up animation.
    bool         m_SameAnimationRequested; // If the same animation was requested this frame.

  public:
    Animator(AnimationID initial_animation) :
      m_Roots{},
      m_CurrentAnimation{initial_animation},
      m_CurrentTransition{},
      m_NextAnimation{initial_animation},
      m_SameAnimationRequested{false}
    {
    }

    // ... Functions for adding animations and transitions ...
};

