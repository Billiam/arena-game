local View = require('view.hulk')
local Hulk = require('model.hulk')

return function(position, entities)
  local entity = Hulk.create(position, entities)
  entity:add(View.create())

  return entity
end
