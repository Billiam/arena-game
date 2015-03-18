return function(bullet, grunt)
  --destroy bullet and grunt
  bullet:kill()
  grunt:move(grunt.position + bullet.velocity * bullet.mass)
  grunt:kill()
end