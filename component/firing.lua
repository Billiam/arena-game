local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Firing = {}
Firing.__index = Firing

function Firing.create(bulletList) 
  local instance = {
    bulletList = bulletList,
    accumulator = 0
  }
  setmetatable(instance, Firing)
  
  return instance
end

function Firing:update(player, dt)
  self.accumulator = self.accumulator + dt

  if not player.isFiring then
    return
  end
  
  local bullets = player:fire(self.accumulator)
  self.accumulator = 0

  if bullets and self.bulletList then
    local kick = Vector(0,0)
    for i,bullet in ipairs(bullets) do
      self.bulletList:add(bullet)
      kick = kick + bullet.velocity:rotated(math.pi) * bullet.mass * 0.1
    end
    
    if kick:len2() then
      player:move(player.position + kick)
    end
  end
end

return Firing