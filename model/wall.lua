local Collidable = require('model.mixin.collidable')

local Wall = {
  isWall = true,
  colliderType = 'wall',
}

Wall.__index = Wall

Collidable:mixInto(Wall)

function Wall.create(position, width, height)
  local instance = {
    position = position:clone(),
    width = width,
    height = height,
  }
  
  setmetatable(instance, Wall)
  
  return instance
end

return Wall