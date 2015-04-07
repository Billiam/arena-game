local Controller = require('lib.controller')
local PlayerInput = {
  type = 'player_input'
}

PlayerInput.__index = PlayerInput
  
function PlayerInput.create(index)
  local instance = {
    index = index or 1
  }
  setmetatable(instance, PlayerInput)
  
  return instance
end

function PlayerInput:update(player, dt)
  player.isFiring = false
  
  if not player.isAlive then
    return
  end
  
  local move, aim = Controller.player(self.index)
  
  player.isFiring = aim:len2() > 0
  local moving = move:len2() > 0
  
  if player.isFiring then
    player.angle = math.atan2(aim.y, aim.x)
  else
    if moving then
      player.angle = math.atan2(move.y, move.x)
    end
  end

  player.velocity = move:clone() * player.speed

  if moving then
    player:move(player.position + player.velocity * dt)
  end
end

return PlayerInput