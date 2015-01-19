local Collection = require('model.collection')

local WaveCollection = {}
WaveCollection.__index = WaveCollection
setmetatable(WaveCollection, {__index = Collection})

function WaveCollection.create(collider)
  local instance = {
    list = {},
    partitionedList = {},
    collider = collider,
    entityIndices = {}
  }
  
  setmetatable(instance, WaveCollection)
  return instance
end

function WaveCollection:update(dt, player)
  for i,entity in ipairs(self.list) do
    entity:update(dt, player)
  end
end

function WaveCollection:next(type)
  local entities = self:type(type)

  if #entities == 0 then
    return nil
  end

  local index = self.entityIndices[type] and self.entityIndices[type] + 1 or 1
  -- restart loop at 1, instead of modding
  -- and potentially skipping entities
  if index > #entities then
    index = 1
  end

  self.entityIndices[type] = index

  return entities[index]
end

function WaveCollection:nearest(position, type)
  local collection

  if type then
    collection = self:type(type)
  else
    collection = self.list
  end

  local distance
  local closest

  for i,entity in ipairs(collection) do
    local entityDistance = entity.position:dist(position)

    if entity.isAlive and (distance == nil or entityDistance < distance) then
      distance = entityDistance
      closest = entity
    end
  end

  return closest
end

function WaveCollection:requiredEnemies()
  return #self:type('grunt')
end

function WaveCollection:roundComplete()
  return self:requiredEnemies() == 0
end

return WaveCollection