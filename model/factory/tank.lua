local View = require('view.tank')
local Tank = require('model.tank')
local Limiter = require('model.factory.limiter')

return function(entityLimiter)
  local entity = Tank.create(entityLimiter)
  entity:add(View.create())

  return entity
end


