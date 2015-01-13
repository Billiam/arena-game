return function(barrier, grunt)
  if barrier.isAlive and grunt.isAlive then
    barrier.isAlive = false
    grunt:kill()
  end
end