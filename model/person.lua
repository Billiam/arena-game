local Collidable = require('model.mixin.collidable')
local beholder = require('vendor.beholder')
local Vector = require('vendor.h.vector')
local Geometry = require('lib.geometry')

local Person = {
  isPerson = true,
  type = 'person',
  colliderType = 'person',
  height = 26,
  width = 14,
  
  speed = 20,
  isAlive = true,
  
  panic = 0.1
}

Person.__index = Person
Collidable:mixInto(Person)

function Person.create(position)
  local instance = {
    position = position:clone(),
    angle = Geometry.randomAngle(),
  }
  
  setmetatable(instance, Person)
  
  return instance
end

function Person:updatePanic(dt)
  --calculate odds that person will turn somewhere else for no reason
  local deltaOdds = 1 - math.pow(1 - self.panic, dt)
  local changed = love.math.random() <= deltaOdds
  
  if changed then
    self:reset()
  end
end

function Person:rescue()
  self.isAlive = false
  beholder.trigger('RESCUE', self)
end

function Person:kill()
  self.isAlive = false
end

function Person:update(dt)
  self:updatePanic(dt)
  self:move(self.position + Vector.fromAngle(self.angle, self.speed) * dt)
end

function Person:reset()
  self.angle = Geometry.randomAngle()
end

function Person.collide(person, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isPlayer or other.isBarrier) then
    return 'touch'
  end
end


return Person