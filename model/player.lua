local Player = {}

Player.mt = { __index = Player }
Player.__index = Player

function Player.create(position)
  local instance = {
    position = position:clone(),
    gunPosition = position:clone(),
    angle = 0,
    fireSpeed = 0.01,
    width = 10,
    height = 20,
    speed = 250
  }
  
  local self = setmetatable(instance, Player.mt)
  
  return self
end

return Player