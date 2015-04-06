local View = require('view.enforcer')
local Enforcer = require('model.enforcer')

return function(position, entities)
  local entity = Enforcer.create()
  entity:add(View.create())

  return entity
end
