local beholder = require('vendor.beholder')
local Vector = require('vendor.h.vector')

local Geometry = require('lib.geometry')
local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')

local Tank = require('model.factory.tank')
local cron = require('vendor.cron')

local Quark = {
  isQuark = true,
  type = 'quark',
  colliderType = 'quark',
  speed = 250,
  height = 35,
  width = 35,
  indecision = 4,
  minSpawn = 1,
  maxSpawn = 4,
  isAlive = true
}

Quark.mt = { __index = Quark }

Composable:mixInto(Quark)
Collidable:mixInto(Quark)

function Quark.create(entityLimiter)
  local instance = {
    position = nil,
    entityLimiter = entityLimiter,
    timers = {},
    tankCount = 0
  }

  setmetatable(instance, Quark.mt)

  instance:reset()

  return instance
end

function Quark:spawn(dt)
  if not self.isAlive then
    return
  end

  if self.entityLimiter.tank:isLimited() then
    self:resetSpawntime()
    return
  end

  if self.tankCount < self.maxTanks then
    self.tankCount = self.tankCount + 1

    local tank = Tank(self.entityLimiter)
    tank.position = self.position
    beholder.trigger('SPAWN', tank)

    if self.tankCount == self.maxTanks then
      self:done()
    else
      self:resetSpawntime()
    end
  end
end

function Quark:rotate(angle)
  self.velocity:rotate_inplace(angle)
  self:resetRedirection()
end

function Quark:resetRedirection()
  self.timers.redirect = cron.after(4 + self.indecision * love.math.random(), self.redirect, self)
end

function Quark:redirect()
  local angle = math.floor(love.math.random() * 4) * Geometry.QUARTERCIRCLE + Geometry.QUARTERCIRCLE/2
  self.velocity = Vector.fromAngle(angle, self.speed)
  self:resetRedirection()
end

function Quark:updateTimers(dt)
  for name,timer in pairs(self.timers) do
    timer:update(dt)
  end
end

function Quark:update(dt, player)
  self:updateComponents(self, dt, player)

  if not player.isAlive then
    return
  end

  self:updateTimers(dt)

  self:updatePosition(dt, player)
end

function Quark:updatePosition(dt, player)
  self:move(self.position + self.velocity * dt)
end

function Quark:render()
  self:renderComponents(self)
end

function Quark:resetSpawntime()
  self.timers.spawn = cron.after(self.minSpawn  + love.math.random() * (self.maxSpawn - self.minSpawn), self.spawn, self)
end

function Quark:reset()
  self.maxTanks = love.math.random(1, 6)
  self.tankCount = 0
  self:resetSpawntime()
  self:redirect()
end

function Quark:collidable()
  return self.isAlive
end

function Quark.collide(quark, other)
  if other.isWall then
    return 'touch'
  elseif other.isAlive then
    if other.isPlayer or other.isBullet then
      return 'touch'
    end
  end
end

function Quark:done()
  self.isAlive = false
end

function Quark:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

return Quark