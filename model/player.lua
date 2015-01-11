local Vector = require('vendor.h.vector')
local Gun = require('model.gun')

local Player = {
  isPlayer = true,
  colliderType = 'player',
}

Player.__index = Player

local gunDistance = 20

function Player.create(input, firing, position)
  local instance = {
    position = position:clone(),
    angle = 0,
    gun = Gun.none(),
    width = 10,
    height = 20,
    speed = 250,

    isFiring = false,
    isAlive = true,
    
    input = input,
    firing = firing,
  }
  
  local self = setmetatable(instance, Player)
  
  return self
end

function Player:setGun(gun)
  self.gun = gun
end

function Player:fire()
  return self.gun:fire(self)
end

function Player:update(dt)
  self.input:update(self, dt)
  self.firing:update(self, dt)
end

function Player:gunPosition()
  return Vector(
    self.position.x + self.width/2 + gunDistance * math.cos(self.angle) , 
    self.position.y + self.height/2 + gunDistance * math.sin(self.angle)
  )
end

function Player.collide(player, other)
  if other.isAlive and (other.isRobot or other.isBarrier) then 
    return 'touch'
  elseif other.isWall then
    return 'slide'
  end
end

return Player