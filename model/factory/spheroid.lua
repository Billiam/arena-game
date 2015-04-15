local View = require('view.spheroid')
local Spheroid = require('model.spheroid')

return function(entities, entityLimiter)
  local entity = Spheroid.create(entityLimiter)
  entity:add(View.create())

  return entity
end
