local beholder = require('vendor.beholder')
local Controller = require('lib.controller')
local PlayerInput = {}
PlayerInput.__index = PlayerInput
  
function PlayerInput.create(index)
  local instance = {
    index = index or 1
  }
  setmetatable(instance, PlayerInput)
  
  return instance
end

function PlayerInput:update(player, dt)
  local move, aim = Controller.player(self.index)
  local aiming = aim:len2() > 0
  local moving = move:len2() > 0
  
  if aiming then
    player.isFiring = true
    player.angle = math.atan2(aim.y, aim.x)
  else
    player.isFiring = false
    
    if moving then
      player.angle = math.atan2(move.y, move.x)
    end
  end
  
  if moving then 
    player:move(player.position + move * player.speed * dt)
  end
end

return PlayerInput