local Death = require('model.death')
local View = require('view.bullet')
local Timeout = require('component/timeout')

return function(entity)
  local entity = Death.create(entity)
  entity:add(View.create())
  entity:add(Timeout.create(8/60))

  return { entity }
end
