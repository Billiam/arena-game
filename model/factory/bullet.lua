local View = require('view.bullet')
local Bullet = require('model.bullet')

return function(position, angle, speed)
  local entity = Bullet.create(position, angle, speed)
  entity:add(View.create())

  return entity
end
