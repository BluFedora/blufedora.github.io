
  // The 'Animator::requestAnimation' function with error handling omitted.
  // Return true if we could make the transition
  // Otherwise false if the animation request could not be completed.
bool Animator::requestAnimation(AnimationID animation)
{
  const auto& transitions   = m_Roots[m_CurrentAnimation].transitions;
  const auto  transition_it = transitions.find(animation);

  // If we tried to do the same animation.
  if (animation == m_CurrentAnimation)
  {
    m_SameAnimationRequested = true;
  }

  // If we found a transition to the requested animation.
  if (transition_it != transitions.end())
  {
    // If we have a new animation or the same is requested.
    if (m_SameAnimationRequested || m_CurrentAnimation != m_NextAnimation)
    {
      const auto& transitions_next   = m_Root[m_NextAnimation].transitions;
      const auto  transition_next_it = transitions2.find(animation);

      // Only allow this transition if both the current animation and
      // last requested animation agree on letting this animation be next.
      if (transition_it->second.can_interrupt          &&
          transition_next_it != transitions_next.end() &&
          transition_next_it->second.can_interrupt)
      {
        m_CurrentTransition = transition_it->second;
        m_NextAnimation     = animation;
      }
    }
    // Otherwise we check if the current animation allows
    // itself to be interrupted by the new animation.
    else if (!m_SameAnimationRequested || transition_it->second.can_interrupt)
    {
      m_CurrentTransition = transition_it->second; 
      m_NextAnimation     = animation;
    }
    else
    {
      return false;
    }

    // We transitoned successfully.
    return true;
  }

  // We could not transition.
  return false;
}
