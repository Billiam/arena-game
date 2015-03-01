local Timer = require('lib.timer')
local Collidable = require('model.mixin.collidable')
local Vector = require('vendor.h.vector')
local Geometry = require('lib.geometry')

local Hulk = {
  isHulk = true,
  type = 'hulk',
  colliderType = 'hulk',
  height = 28,
  width = 26,
  speed = 65,
  isAlive = true
}

Hulk.__index = Hulk
Collidable:mixInto(Hulk)

local function randomAngle()
  return math.floor(love.math.random() * 4) * Geometry.QUARTERCIRCLE
end

local function attentiveness()
  return 0.25 + love.math.random() + 2.5
end

function Hulk.create(position, world)
  local instance = {
    position = Vector.new(0, 0),
    timer = Timer.create(attentiveness()),
    world = world,

    angle = randomAngle(),
    target = nil,
    components = {},
  }

  setmetatable(instance, Hulk)

  return instance
end

function Hulk:add(component)
  self.components[component.type] = component

  return self
end

function Hulk:update(dt, player)
  self.timer:update(dt)

  if self.timer:expired() or self:closeToTarget() then
    self:reset(player)
  end

  self:move(self.position + Vector.fromAngle(self.angle, self.speed) * dt)
end

function Hulk:closeToTarget()
  return self:distanceFromTarget() < 5
end

function Hulk:distanceFromTarget()
  if self.target and self.target.isAlive then
    return self.position:dist(self.target.position)
  else
    return 0
  end
end

function Hulk:newPosition(player)
  -- find a new target
  if not (self.target and self.target.isAlive) then
    local nextTarget = self.world:next('person')
    self.target = nextTarget or player
  end

  local missAmount = Vector(love.math.random() * 60 - 30, love.math.random() * 60 - 30)
  local angle = Geometry.lineAngle(self.target.position + missAmount, self.position)

  -- constrain angle to prevent 180 degree turns
  local angleChange = Geometry.radianDiff(self.angle, angle)

  -- if greater than 1/16th circle, rotate in given direction
  if angleChange > math.pi/8 then
    self.angle = self.angle - Geometry.QUARTERCIRCLE
  elseif angleChange < -math.pi/8 then
    self.angle = self.angle + Geometry.QUARTERCIRCLE
  end
end

function Hulk:reset(player)
  self:newPosition(player)
  self.timer:reset(attentiveness())
end

function Hulk:render()
  for type,component in pairs(self.components) do
    if component.render then
      component:render(self)
    end
  end
end

function Hulk.collide(hulk, other)
  if other.isWall then
    return 'bounce'
  elseif other.isAlive and (other.isPlayer or other.isBarrier or other.isPerson) then
    return 'touch'
  end
end

return Hulk