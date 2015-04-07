local View = require('view.spark')
local Spark = require('model.spark')

return function(position, velocity)
  local entity = Spark.create(position, velocity)
  entity:add(View.create())

  return entity
end
