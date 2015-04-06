local beholder = require('vendor.beholder')
local Vector = require('vendor.h.vector')

local Geometry = require('lib.geometry')
local Timer = require('lib.timer')
local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')

local Enforcer = require('model.factory.enforcer')
local cron = require('vendor.cron')


local Spheroid = {
  isSpheroid = true,
  type = 'spheroid',
  colliderType = 'spheroid',
  height = 35,
  width = 35,
  thrust = 5,
  indecision = 2,
  minSpawn = 1.5,
  maxSpawn = 4,
  torque = math.rad(270),
  isAlive = true
}

Spheroid.mt = { __index = Spheroid }

Composable:mixInto(Spheroid)
Collidable:mixInto(Spheroid)

local function spawnDelay()
  return love.math.random() + 2.5
end

function Spheroid.create(position)
  local instance = {
    position = position,
    timers = {},
    hidden = false,
  }

  setmetatable(instance, Spheroid.mt)

  instance:reset()

  return instance
end

function Spheroid:spawn(dt)
  if not self.isAlive then
    return
  end

  local count = #self.enforcers

  if count < self.enforcerCount then
    local enforcer = Enforcer()
    enforcer.position = self.position
    table.insert(self.enforcers, enforcer)

    beholder.trigger('SPAWN', enforcer)

    if count == self.enforcerCount - 1 then
      self:hide()
    else
      self:resetSpawntime()
    end
  end
end

function Spheroid:hide()
  self.hidden = true
end

function Spheroid:redirect()
  self.targetAngle = Geometry.randomAngle()

  self.timers.redirect = cron.after(0.75 + self.indecision * love.math.random(), self.redirect, self)
end

function Spheroid:updateTimers(dt)
  for name,timer in pairs(self.timers) do
    timer:update(dt)
  end
end

function Spheroid:update(dt, player)
  self:updateComponents(self, dt, player)
  self:checkEnforcers()
  if not player.isAlive then
    return
  end

  self:updateTimers(dt)

  self:rotate(dt, player)
  self:updatePosition(dt, player)
end

function Spheroid:hasLiveChildren()
  for i, enforcer in ipairs(self.enforcers) do
    if enforcer.isAlive then
      return true
    end
  end

  return false
end

function Spheroid:checkEnforcers()
  if not self.hidden then
    return
  end

  if not self:hasLiveChildren() then
    self.isAlive = false
  end
end

function Spheroid:updatePosition(dt, player)
--  local distance = self.position:dist2(player.position)
  local thrust = self.thrust
--  if distance < self.width * 5 then
--    thrust = self.thrust * 4
--  end

  self.velocity = (self.velocity + Vector.fromAngle(self.angle, thrust) * dt) * math.pow(0.7, dt)

  self:move(self.position + self.velocity)
--  self.position = self.position + self.velocity
end

function Spheroid:render()
  self:renderComponents(self)
end

function Spheroid:resetSpawntime()
  self.timers.spawn = cron.after(self.minSpawn  + love.math.random() * (self.maxSpawn - self.minSpawn), self.spawn, self)
end

function Spheroid:rotate(dt)
  local angleDifference = Geometry.radianDiff(self.targetAngle, self.angle)
  local direction = angleDifference > 0.2 and 1 or angleDifference < -0.2 and -1 or 0

  self.angle = self.angle + direction * self.torque * dt
end

function Spheroid:reset()
  self.velocity = Vector.new(0, 0)
  self.angle = Geometry.randomAngle()
  self.enforcers = {}
  self.enforcerCount = love.math.random(1, 6)
  self.hidden = false
  self:resetSpawntime()
  self:redirect()
end

function Spheroid:collidable()
  return self.isAlive and not self.hidden
end

function Spheroid.collide(spheroid, other)
  if spheroid.hidden then
    return nil
  end

  if other.isWall then
    return 'slide'
  elseif other.isAlive then
    if other.isPlayer or other.isBullet then
      return 'touch'
    end
  end
end

function Spheroid:kill()
  if self:hasLiveChildren() then
    self.isAlive = false
  else
    self:hide()
  end
  beholder.trigger('KILL', self)
end

return Spheroid