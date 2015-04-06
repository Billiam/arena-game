local Vector = require('vendor.h.vector')
local Composable = require('model.mixin.composable')
local Collidable = require('model.mixin.collidable')
local beholder = require('vendor.beholder')

local Bullet = {
  mass = 0.005,
  isBullet = true,
  colliderType = 'bullet',
  type = 'bullet',
  isAlive = true
}
Bullet.mt = { __index = Bullet }

Composable:mixInto(Bullet)
Collidable:mixInto(Bullet)

function Bullet.create(position, angle, speed)
  local instance = {
    position = position:clone(),
    velocity = Vector(speed * math.cos(angle), speed * math.sin(angle)),
    width = 5,
    height = 5,
  }
  
  setmetatable(instance, Bullet.mt)
  
  return instance
end

function Bullet:render()
  self:renderComponents(self)
end

function Bullet:update(dt)
  self:updateComponents(self, dt)

  self:move(self.position + self.velocity * dt)
end

function Bullet:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

function Bullet.collide(bullet, other)
  if other.isWall or other.isAlive and (other.isBarrier or other.isGrunt or other.isHulk or other.isSpheroid or other.isEnforcer) then
    return 'touch'
  end
end

return Bullet