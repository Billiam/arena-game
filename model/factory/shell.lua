local View = require('view.shell')
local Shell = require('model.shell')

return function(position, velocity)
  local entity = Shell.create(position, velocity)
  entity:add(View.create())

  return entity
end
