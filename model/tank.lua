local beholder = require('vendor.beholder')
local cron = require('vendor.cron')
local Geometry = require('lib.geometry')
local Vector = require('vendor.h.vector')
local Shell = require('model.factory.shell')

local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')

local Tank = {
  isTank = true,
  type = 'tank',
  colliderType = 'tank',
  height = 30,
  width = 30,
  speed = 100,
  isAlive = true,
  indecision = 0.8,
}
local rounding = Geometry.QUARTERCIRCLE


Tank.mt = { __index = Tank }

Composable:mixInto(Tank)
Collidable:mixInto(Tank)

function Tank.create(entityLimiter)
  local instance = {
    position = nil,
    timers = {},
    entityLimiter = entityLimiter
  }

  setmetatable(instance, Tank.mt)
  instance:reset()

  return instance
end

function Tank:update(dt, player)
  self.player = player

  self:updateComponents(self, dt, player)
  if not player.isAlive then
    return
  end

  if not self.timers.heading then
    self:updateHeading()
  end

  for i,timer in pairs(self.timers) do
    timer:update(dt)
  end

  self:updatePosition(dt, player)
end

function roundAngle(angle)
  return math.floor(angle/rounding) * rounding + rounding/2
end

function Tank:reset()
  self.velocity = Vector.fromAngle(roundAngle(Geometry.randomAngle()), self.speed)

  self:resetFire()
end

function Tank:rotate(angle)
  self.velocity = Vector.fromAngle(roundAngle(angle), self.velocity:len())
end

function Tank:updateHeading()
  local angle

  if love.math.random() < 0.3 then
    angle = Geometry.lineAngle(self.player.position, self.position)
  else
    angle = Geometry.randomAngle()
  end

  self:rotate(angle)

  self:setHeadingTimer()
end

function Tank:setHeadingTimer()
  self.timers.heading = cron.after(love.math.random() + 1, self.updateHeading, self)
end

function Tank:updatePosition(dt, player)
  self:move(self.position + self.velocity * dt)
end

function Tank:render()
  self:renderComponents(self)
end

function Tank.collide(tank, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive then
    if other.isPlayer or other.isBullet then
      return 'touch'
    end
  end
end

function Tank:center()
  return self.position + Vector.new(self.width/2, self.height/2)
end

function Tank:fire()
  if not self.entityLimiter.shell:isLimited() then
    local inaccuracy = Geometry.HALFCIRCLE * (love.math.random() - 0.5) * 0.1
    local angle = Geometry.lineAngle(self.player:center(), self.position) + inaccuracy
    local dist = self.position:dist2(self.player.position)
    local speed = math.max(80, math.min(400, dist/150))
    local velocity = Vector.fromAngle(angle, speed)

    -- predict player movement 10% of the time
    if love.math.random() < 0.1 then
      velocity = velocity + self.player.velocity
    end

    local shell = Shell(self:center(), velocity)
    beholder.trigger('SPAWN', shell)
  end

  self:resetFire()
end

function Tank:resetFire()
  self.timers.fire = cron.after(love.math.random() * 3.5 + 0.35, self.fire, self)
end

function Tank:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

return Tank