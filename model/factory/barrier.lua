local View = require('view.barrier')
local Barrier = require('model.barrier')

return function(position, entities)
  local entity = Barrier.create(position, entities)
  entity:add(View.create())

  return entity
end
