local Vector = require('vendor.h.vector')

return function(hulk, wall, collision)
  --reverse normal vector angle so that incoming angle can be compared easily
  local normalAngle = Vector(collision.normal.x, collision.normal.y):angleTo()

  local randomFactor

  -- occasionally stick to a wall
  if love.math.random() < 0.15 then
    randomFactor = love.math.random(0,1)
  else
    randomFactor = love.math.random()
  end

  local newDirection = normalAngle + (math.pi * randomFactor - math.pi * 0.5)

  hulk:redirect(newDirection)
end