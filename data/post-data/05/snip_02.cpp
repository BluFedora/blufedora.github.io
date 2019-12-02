
  // Return true if we changed the animation.
  // Otherwise false if the animation has not been changed.
bool Animator::update(AnimationComponent& animation_component)
{
  m_SameAnimationRequested = false;

  if (m_NextAnimation != m_CurrentAnimation)
  {
    if (m_CurrentTransition.can_interrupt || animation_component.isAnimationDone())
    {
      m_CurrentAnimation = m_NextAnimation;
      animation_component.setAnimation(m_CurrentAnimation);
      return true;
    }
  }

  return false;
}

