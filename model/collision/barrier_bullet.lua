return function(barrier, bullet)
  if barrier.isAlive and bullet.isAlive then
    barrier:kill()
    bullet:kill()
  end
end