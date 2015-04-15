local Vector = require('vendor.h.vector')

local Firing = {
  type = 'firing'
}
Firing.__index = Firing

function Firing.create(entities)
  local instance = {
    accumulator = 0
  }
  setmetatable(instance, Firing)
  
  return instance
end

function Firing:update(player, dt)
  if not player.isFiring then
    return
  end

  player:fire()
end

return Firing