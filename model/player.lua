local Vector = require('vendor.h.vector')
local Gun = require('model.gun')
local Composable = require('model.mixin.composable')
local Collidable = require('model.mixin.collidable')

local Player = {
  isPlayer = true,
  type = 'player',
  colliderType = 'player',
  width = 12,
  height = 26,
}

Player.__index = Player

Composable:mixInto(Player)
Collidable:mixInto(Player)

local gunDistance = 10

function Player.create(position, health)
  local instance = {
    position = position:clone(),
    angle = 0,
    gun = Gun.none(),

    speed = 165,

    isFiring = false,
    isAlive = true,

    health = health,
    components = {}
  }
  
  local self = setmetatable(instance, Player)
  
  return self
end

function Player:lives()
  return self.health.value
end

function Player:kill()
  if self.isAlive then
    self.health:remove(self)
  end
end

function Player:setGun(gun)
  self.gun = gun
end

function Player:reset()
  self.isAlive = true
  self:resetComponents(self)
end

function Player:fire(dt, activeBullets)
  return self.gun:fire(dt, self, activeBullets)
end

function Player:update(dt)
  self:updateComponents(self, dt)
end

function Player:render()
  self:renderComponents(self)
end

function Player:gunPosition()
  return Vector(
    self.position.x + self.width/2 + gunDistance * math.cos(self.angle),
    self.position.y + self.height/2 + gunDistance * math.sin(self.angle)
  )
end

function Player.collide(player, other)
  if other.isAlive and (other.isGrunt or other.isBarrier) then 
    return 'touch'
  elseif other.isWall then
    return 'slide'
  end
end

return Player