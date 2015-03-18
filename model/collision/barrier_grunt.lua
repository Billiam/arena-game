return function(barrier, grunt)
  if barrier.isAlive and grunt.isAlive then
    barrier:kill()
    grunt:kill()
  end
end