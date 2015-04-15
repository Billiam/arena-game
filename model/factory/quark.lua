local View = require('view.quark')
local Quark = require('model.quark')

return function(entities, entityLimiter)
  local entity = Quark.create(entityLimiter)
  entity:add(View.create())

  return entity
end
