local View = require('view.grunt')
local Grunt = require('model.grunt')

return function(entities)
  local entity = Grunt.create()
  entity:add(View.create())

  return entity
end
