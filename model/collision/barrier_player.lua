return function(barrier, player)
  if barrier.isAlive and player.isAlive then
    player.isAlive = false
    player:kill()
  end
end