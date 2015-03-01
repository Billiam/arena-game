local beholder = require('vendor.beholder')
local Collidable = require('model.mixin.collidable')
local Geometry = require('lib.geometry')
local Vector = require('vendor.h.vector')

local Grunt = {
  isGrunt = true,
  type = 'grunt',
  colliderType = 'grunt',
  height = 24,
  width = 18,
  isAlive = true,
  distance = 12,
  minimumStep = 0.035,
}

Grunt.__index = Grunt
Collidable:mixInto(Grunt)

function Grunt.create()
  local instance = {
    position = Vector.new(0, 0),
    angle = love.math.random() * math.pi * 2,
    nextStep = love.math.random() * 0.4 + 0.2,
    accumulator = 0,
    patience = 1,
    components = {},
  }
  
  local self = setmetatable(instance, Grunt)
  
  return self
end

function Grunt:update(dt, player)
  for type,component in pairs(self.components) do
    if component.update then
      component:update(self, dt, player)
    end
  end

  self.accumulator = self.accumulator + dt
  
  if self.accumulator >= self.nextStep then
    self.patience = math.max(0, 1 - self.accumulator/30)

    self.nextStep = self.accumulator + self.minimumStep + self.patience * 0.2
    
    self:step(dt, player)
  end
end

function Grunt:step(dt, player)
  local newPosition = self.position + (player.position - self.position):normalize_inplace() * self.distance
  self.angle = Geometry.lineAngle(self.position, newPosition)
  self:move(newPosition)
end

function Grunt:add(component)
  self.components[component.type] = component

  return self
end

function Grunt:reset()
  self.patience = 1
  self.accumulator = 0
  self.nextStep = love.math.random() + 1
end

function Grunt.collide(grunt, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isPlayer or other.isBarrier) then
    return 'touch'
  end
end

function Grunt:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

function Grunt:render()
  for type,component in pairs(self.components) do
    if component.render then
      component:render(self)
    end
  end
end

return Grunt