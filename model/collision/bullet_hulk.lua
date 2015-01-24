return function(bullet, hulk)
  bullet.isAlive = false

  hulk:move(hulk.position + bullet.velocity * bullet.mass * 0.5)
end