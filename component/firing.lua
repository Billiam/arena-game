local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Firing = {}
Firing.__index = Firing

function Firing.create(bulletList) 
  local instance = {
    bulletList = bulletList
  }
  setmetatable(instance, Firing)
  
  return instance
end

function Firing:update(player, dt)
  if not player.isFiring then
    return
  end
  
  local bullets = player:fire(dt)

  if bullets and self.bulletList then
    local kick = Vector(0,0)
    for i,bullet in ipairs(bullets) do
      self.bulletList:add(bullet)
      kick = kick + bullet.velocity:rotated(math.pi) * bullet.mass
    end
    
    if kick:len2() then
      player.position = player.position + kick
      beholder.trigger('COLLIDEMOVE', player)
    end
  end
end

return Firing