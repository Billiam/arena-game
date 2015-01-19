local Vector = require('vendor.h.vector')
local Geometry = require('lib.geometry')

return function(person, wall, collision)
  --reverse normal vector angle so that incoming angle can be compared easily
  local normalAngle = Vector(collision.normal.x, collision.normal.y):angleTo()
  local angleDifference = Geometry.radianDiff(normalAngle, person.angle)

  local direction = 1
  
  if angleDifference == 0 then
    direction = love.math.random() < 0.5 and -1 or 1
  elseif angleDifference > 0 then
    direction = -1
  else 
    direction = 1
  end
  
  person.angle = normalAngle + Geometry.QUARTERCIRCLE * direction
end