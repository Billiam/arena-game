local Barrier = {
  isBarrier = true,
  colliderType = 'barrier',
  type = 'barrier',
  isAlive = true,
}

Barrier.__index = Barrier

function Barrier.create(position, width, height)
  local instance = {
    position = position:clone(),
    width = width,
    height = height,
  }
  
  setmetatable(instance, Barrier)
  
  return instance
end

function Barrier:update() end

return Barrier