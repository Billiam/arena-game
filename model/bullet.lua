local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Bullet = {
  mass = 0.005,
  isBullet = true,
  colliderType = 'bullet',
  isAlive = true
}
Bullet.__index = Bullet

function Bullet.create(position, angle, speed)
  local instance = {
    position = position:clone(),
    velocity = Vector(speed * math.cos(angle), speed * math.sin(angle)),
    width = 10,
    height = 10
  }
  
  setmetatable(instance, Bullet)
  
  return instance
end

function Bullet:update(dt)
  self.position = self.position + self.velocity * dt
  beholder.trigger('COLLIDEMOVE', self)
end

function Bullet.collide(bullet, other)
  if other.isWall or other.isAlive and (other.isBarrier or other.isGrunt or other.isHulk) then
    return 'touch'
  end
end

return Bullet