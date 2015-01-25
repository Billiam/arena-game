local Collection = {}
Collection.__index = Collection

function Collection.create(collider)
  local instance = {
    list = {},
    partitionedList = {},
    collider = collider
  }
  
  setmetatable(instance, Collection)
  
  return instance
end

function Collection:removeDead()
  local dead = {}
  
  for i=#self.list, 1, -1 do
    if not self.list[i].isAlive then
      table.insert(dead, self.list[i])
      self:removeElement(self.list[i])
    end
  end
  
  return dead
end

function Collection:zSorted(additional)
  local collection = {}

  table.insert(collection, additional)
  for i,v in ipairs(self.list) do
    table.insert(collection, v)
  end
  table.sort(collection, function(a, b) return a.position.y + a.height < b.position.y + b.height end)

  return collection
end

function Collection:type(type)
  if not self.partitionedList[type] then
    self.partitionedList[type] = {}
  end

  return self.partitionedList[type]
end

function Collection:add(element)
  table.insert(self.list, element)
  
  if element.type then
    if not self.partitionedList[element.type] then
      self.partitionedList[element.type] = {}
    end
    
    table.insert(self.partitionedList[element.type], element)
  end
  self.collider:add(element, element.position.x, element.position.y, element.width, element.height)
end

function Collection:remove(index)
  self:removeElement(self.list[index], index)
end

function Collection:removeElement(element, index)
  table.remove(self.list, index or self:findIndex(element))
  self.collider:remove(element)
   
  if element.type then
    table.remove(self.partitionedList[element.type], self:findIndex(element, self.partitionedList[element.type]))
  end
end

function Collection:clear()
  for i=#self.list,1,-1 do
    self:remove(i)
  end
end

function Collection:findIndex(element, list)
  list = list or self.list
  
  for index, value in pairs(list) do
    if value == element then
      return index
    end
  end
end

return Collection