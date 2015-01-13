return function(barrier, player)
  if barrier.isAlive and player.isAlive then
    player:kill()
  end
end