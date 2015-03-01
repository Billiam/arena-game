local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Bullet = {
  mass = 0.005,
  isBullet = true,
  colliderType = 'bullet',
  type = 'bullet',
  isAlive = true
}
Bullet.__index = Bullet

function Bullet.create(position, angle, speed)
  local instance = {
    position = position:clone(),
    velocity = Vector(speed * math.cos(angle), speed * math.sin(angle)),
    width = 5,
    height = 5,
    components = {}
  }
  
  setmetatable(instance, Bullet)
  
  return instance
end

function Bullet:add(component)
  self.components[component.type] = component

  return self
end

function Bullet:render()
  for type,component in pairs(self.components) do
    if component.render then
      component:render(self)
    end
  end
end

function Bullet:update(dt)
  for name,component in pairs(self.components) do
    if component.update then
      component:update(self, dt)
    end
  end
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