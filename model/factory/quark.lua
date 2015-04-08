local View = require('view.quark')
local Quark = require('model.quark')

return function(position, entities)
  local entity = Quark.create()
  entity:add(View.create())

  return entity
end
