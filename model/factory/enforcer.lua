local View = require('view.enforcer')
local Enforcer = require('model.enforcer')

return function(entities, entityLimiter)
  local entity = Enforcer.create(entityLimiter)
  entity:add(View.create())

  return entity
end
