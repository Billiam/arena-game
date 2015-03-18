local Death = require('model.death')
local View = require('view.grunt')
local Timeout = require('component.timeout')

return function(grunt)
  local entity = Death.create(grunt)
  entity:add(View.create())
  entity:add(Timeout.create(1))

  return { entity }
end