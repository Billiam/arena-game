return function(barrier, grunt)
  if barrier.isAlive and grunt.isAlive then
    barrier.isAlive = false
    grunt.isAlive = false
  end
end