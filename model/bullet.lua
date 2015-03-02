local Vector = require('vendor.h.vector')
local Composable = require('model.mixin.composable')

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

  self.position = self.position + self.velocity * dt
  beholder.trigger('COLLIDEMOVE', self)
end

function Bullet.collide(bullet, other)
  if other.isWall or other.isAlive and (other.isBarrier or other.isGrunt or other.isHulk) then
    return 'touch'
  end
end

return Bullet