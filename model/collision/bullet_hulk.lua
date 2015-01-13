return function(bullet, hulk)
  bullet.isAlive = false

  hulk:move(hulk.position + bullet.velocity * bullet.mass)
end