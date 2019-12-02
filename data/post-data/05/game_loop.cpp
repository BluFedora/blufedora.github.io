
  //
  // This is an example of how the API looks
  //

  // The main update loop.
void UpdateLoop()
{
    // Somewhere in the 'Player Attack Controller'
  if (Input::IsButton(Button::B))
  {
    player.RequestAnimation(PlayerAnimation::ATTACK_MELEE);
  }

    // Somewhere in the 'Player Movement Controller'
  if (player.IsMoving())
  {
    player.RequestAnimation(PlayerAnimation::RUN);
  }
  else
  {
    player.RequestAnimation(PlayerAnimation::IDLE);
  }

    // NOTE:
    //   Even though lower priority animations were requested 
    //   after the higher priority attack, these requests
    //   will be denied / queued up thus not stopping the
    //   attack from happening.

    // At the end of the Update.
  player.UpdateAnimator();
}
