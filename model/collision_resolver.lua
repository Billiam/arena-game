local beholder = require('vendor.beholder')
local requireTree = require('vendor.requireTree')

local CollisionResolver = {}
CollisionResolver.__index = CollisionResolver

local callbacks = requireTree('model.collision')

function CollisionResolver.create(collider)
  local instance = {
    collider = collider,
    listener = nil
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
      callback(collider1, collider2)
    end
  end
end

function CollisionResolver.observe(self, event)
  self.listener = beholder.observe(event, function(...)
    self:move(...)
  end)
end

function CollisionResolver:clear()
  beholder.stopObserving(self.listener)
end

function CollisionResolver:move(item)
  local collisions, len

  item.position.x, item.position.y, collisions, len = self.collider:move(item, item.position.x, item.position.y, item.collide)
  if len > 0 then
    self:handleCollisions(collisions)
  end
end

return CollisionResolver