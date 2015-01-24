local Collidable = require('model.mixin.collidable')

local Barrier = {
  isBarrier = true,
  colliderType = 'barrier',
  type = 'barrier',
  isAlive = true,
  width = 15,
  height = 15
}

Barrier.__index = Barrier

Collidable:mixInto(Barrier)

function Barrier.create(position)
  local instance = {
    position = position:clone(),
  }
  
  setmetatable(instance, Barrier)
  
  return instance
end

function Barrier:update() end
function Barrier:reset() end

return Barrier