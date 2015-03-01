local View = require('view.person')
local person = require('model.person')

return function(position)
  local entity = person.create(position)
  entity:add(View.create())

  return entity
end
