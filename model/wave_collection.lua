local Collection = require('model.collection')

local WaveCollection = {}
WaveCollection.__index = WaveCollection
setmetatable(WaveCollection, {__index = Collection})

function WaveCollection.create(collider)
  local instance = {
    list = {},
    listIndex = {},
    partitionedIndex = {},
    partitionedList = {},
    collider = collider
  }
  
  setmetatable(instance, WaveCollection)
  return instance
end

function WaveCollection:roundComplete()
  return #self.list - (#self:type('barrier') + #self:type('person')) == 0
end

return WaveCollection