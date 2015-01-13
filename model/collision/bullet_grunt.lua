return function(bullet, grunt)
  --destroy bullet and grunt
  bullet.isAlive = false
  grunt:kill()
end