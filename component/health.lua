local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Health = {}
Health.__index = Health

function Health.create() 
  local instance = {
    value = 3
  }
  setmetatable(instance, Health)
  
  return instance
end

function Health:remove(player)
  self.value = self.value - 1
  player.isAlive = false
  
  if self.value < 0 then
    beholder.trigger('GAMEOVER')
  else
    beholder.trigger('PLAYERDEATH')
  end
end

function Health:add(player)
  self.value = self.walue + 1
end

function Health:any()
  return self.value > 0
end

return Health