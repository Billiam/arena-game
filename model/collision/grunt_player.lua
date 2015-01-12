return function(grunt, player)
  if player.isAlive then
    player:kill()
  end
end