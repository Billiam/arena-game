return function(barrier, bullet)
  if barrier.isAlive and bullet.isAlive then
    barrier.isAlive = false
    bullet.isAlive = false
  end
end