local beholder = require('vendor.beholder')
local requireTree = require('vendor.requireTree')

local CollisionResolver = {}
CollisionResolver.__index = CollisionResolver

local callbacks = requireTree('model.collision')

function CollisionResolver.create(collider)
  local instance = {
    collider = collider,
    listeners = {}
  }
  
  setmetatable(instance, CollisionResolver)
  
  return instance
end

local function sortCollision(collision)
  if collision.item.colliderType < collision.other.colliderType then
    return collision.item, collision.other 
  else 
    return collision.other, collision.item
  end
end

local function collisionCallback(collider1, collider2)
  local key = collider1.colliderType .. '_' .. collider2.colliderType
  return callbacks[key]
end

function CollisionResolver:handleCollisions(collisions)
  for i, collision in ipairs(collisions) do
    local collider1, collider2 = sortCollision(collision)
    local callback = collisionCallback(collider1, collider2)
   
    if callback then
      callback(collider1, collider2, collision)
    end
  end
end

function CollisionResolver:observe()
  self.listeners.move = beholder.observe('COLLIDEMOVE', function(...)
    self:move(...)
  end)
  
  self.listeners.place = beholder.observe('COLLIDEUPDATE', function(...)
    self:place(...)
  end)
end

function CollisionResolver:clear()
  for key,id in pairs(self.listeners) do
    beholder.stopObserving(id)
  end
end

function CollisionResolver:place(item)
  if not self.collider:hasItem(item) then
    return
  end

  self.collider:update(item, item.position.x, item.position.y)
end

function CollisionResolver:move(item)
  local collisions, len

  if not self.collider:hasItem(item) then
    return
  end

  item.position.x, item.position.y, collisions, len = self.collider:move(item, item.position.x, item.position.y, item.collide)
  if len > 0 then
    self:handleCollisions(collisions)
  end
end

return CollisionResolver