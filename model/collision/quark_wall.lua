return function(quark, wall, collision)
  local difference = Vector(collision.normal.x, collision.normal.y):angleTo(quark.velocity)
  local direction = love.math.random() < 0.5 and -1 or 1
  quark:rotate(difference + 45 * direction)
end