local View = require('view.spheroid')
local Spheroid = require('model.spheroid')

return function(position, entities)
  local entity = Spheroid.create()
  entity:add(View.create())

  return entity
end
