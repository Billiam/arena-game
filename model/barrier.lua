local Collidable = require('model.mixin.collidable')

local Barrier = {
  isBarrier = true,
  colliderType = 'barrier',
  type = 'barrier',
  isAlive = true,
  width = 30,
  height = 30
}

Barrier.__index = Barrier

Collidable:mixInto(Barrier)

function Barrier.create(position, width, height)
  width = width or Barrier.width
  height = height or Barrier.height
  
  local instance = {
    position = position:clone(),
    width = width,
    height = height,
  }
  
  setmetatable(instance, Barrier)
  
  return instance
end

function Barrier:update() end
function Barrier:reset() end

return Barrier