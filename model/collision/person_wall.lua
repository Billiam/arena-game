local Vector = require('vendor.h.vector')

return function(person, wall, collision)
  local circle = math.pi * 2
  local quarter = math.pi * 0.5
  
  local previousAngle = person.angle
  
  --reverse normal vector angle so that incoming angle can be compared easily
  local normalAngle = Vector(collision.normal.x, collision.normal.y):angleTo()
  local angleDifference = (((previousAngle - (normalAngle + math.pi)) % circle) + quarter) % circle - quarter
  local direction = 1
  
  if angleDifference == 0 then
    direction = love.math.random() < 0.5 and -1 or 1
  elseif angleDifference > 0 then
    direction = -1
  else 
    direction = 1
  end
  
  person.angle = normalAngle + quarter * direction
end