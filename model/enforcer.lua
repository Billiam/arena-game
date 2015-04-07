local beholder = require('vendor.beholder')
local cron = require('vendor.cron')
local Geometry = require('lib.geometry')
local Vector = require('vendor.h.vector')

local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')


local Enforcer = {
  isEnforcer = true,
  type = 'enforcer',
  colliderType = 'enforcer',
  height = 20,
  width = 20,
  speed = 3/4,
  isAlive = true
}

Enforcer.mt = { __index = Enforcer }

Composable:mixInto(Enforcer)
Collidable:mixInto(Enforcer)

function Enforcer.create(position)
  local instance = {
    position = position,
    timers = {}
  }

  setmetatable(instance, Enforcer.mt)

  return instance
end

function Enforcer:update(dt, player)
  self.player = player

  self:updateComponents(self, dt, player)
  if not player.isAlive then
    return
  end

  if not self.target then
    self:updateTarget()
  end

  for i,timer in pairs(self.timers) do
    timer:update(dt)
  end

  self:updatePosition(dt, player)
end

function Enforcer:updateTarget()
  if love.math.random() < 0.005 then
    local otherDirection = Geometry.lineAngle(self.position, self.player.position)
    self.target = Vector.fromAngle(otherDirection, 1500)
  else
    self.target = self.player.position:clone()
  end
  self:setTargettingTimer()
end

function Enforcer:setTargettingTimer()
  self.timers.target = cron.after(love.math.random() + 0.1, self.updateTarget, self)
end

function Enforcer:updatePosition(dt, player)
  self:move(self.position + (self.target - self.position) * dt * self.speed)

  if self.position:dist2(self.target) < 5 then
    self:updateTarget()
  end
end

function Enforcer:render()
  self:renderComponents(self)
end

function Enforcer.collide(enforcer, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive then
    if other.isPlayer or other.isBullet then
      return 'touch'
    end
  end
end

function Enforcer:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

return Enforcer