local Death = require('model.death')
local View = require('view.barrier')

return function(barrier)
  local entity = Death.create(barrier)
  entity:add(View.create())

  return { entity }
end