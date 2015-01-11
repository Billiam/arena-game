local Collection = {}
Collection.__index = Collection

function Collection.create(collider)
  local instance = {
    list = {},
    collider = collider
  }
  
  local self = setmetatable(instance, Collection)
  return self
end

function Collection:removeDead()
  local dead = {}
  for i=#self.list, 1, -1 do
    if not self.list[i].isAlive then
      table.insert(dead, self.list[i])
      self:remove(i)
    end
  end
  
  return dead
end

function Collection:add(element)
  table.insert(self.list, element)
  self.collider:add(element, element.position.x, element.position.y, element.width, element.height)
end

function Collection:remove(index)
  local element = self.list[index]
  self.collider:remove(element)
  table.remove(self.list, index)
end

function Collection:removeElement(element)
  self:remove(self:findIndex(element))
end

function Collection:clear()
  for k in pairs(self.list) do
    self:remove(k)
  end
end

function Collection:findIndex(element)
  for index, value in pairs(self.list) do
    if value == element then
      return index
    end
  end
end

return Collection