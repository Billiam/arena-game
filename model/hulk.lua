local Timer = require('lib.timer')
local Collidable = require('model.mixin.collidable')
local Vector = require('vendor.h.vector')

local Hulk = {
  isHulk = true,
  type = 'hulk',
  colliderType = 'hulk',
  height = 50,
  width = 45,
  speed = 80,
  isAlive = true
}

Hulk.__index = Hulk
Collidable:mixInto(Hulk)

local function randomAngle()
  return love.math.random() * math.pi * 2
end

local function indecision()
  return 0.5 + love.math.random() * 4
end

function Hulk.create(position)
  local instance = {
    position = position:clone(),
    angle = randomAngle(),
    timer = Timer.create(indecision())
  }

  setmetatable(instance, Hulk)

  return instance
end

function Hulk:update(dt)
  self.timer:update(dt)

  if self.timer:expired() then
    self:reset()
  end

  self:move(self.position + Vector.fromAngle(self.angle, self.speed) * dt)
end

function Hulk:redirect(angle)
  self.angle = angle
  self.timer:reset(indecision())
end

function Hulk:reset()
  self:redirect(randomAngle())
end

function Hulk.collide(hulk, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isPlayer or other.isBarrier or other.isPerson) then
    return 'touch'
  end
end


return Hulk