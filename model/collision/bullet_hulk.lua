return function(bullet, hulk)
  bullet:kill()
  hulk:move(hulk.position + bullet.velocity * bullet.mass * 0.5)
end