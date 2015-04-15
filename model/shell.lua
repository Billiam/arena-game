local Vector = require('vendor.h.vector')
local Composable = require('model.mixin.composable')
local Collidable = require('model.mixin.collidable')

local beholder = require('vendor.beholder')
local cron = require('vendor.cron')

local Shell = {
  isShell = true,
  colliderType = 'shell',
  type = 'shell',
  isAlive = true,
  width = 15,
  height = 15,
}
Shell.mt = { __index = Shell }

Composable:mixInto(Shell)
Collidable:mixInto(Shell)

function Shell.create(position, velocity)
  local instance = {
    position = position - Vector.new(Shell.width/2, Shell.height/2),
    velocity = velocity,
  }

  setmetatable(instance, Shell.mt)

  instance.timer = cron.after(3, instance.timeout, instance)

  return instance
end

function Shell:render()
  self:renderComponents(self)
end

function Shell:update(dt, player)
  self:updateComponents(self, dt)

  if not player.isAlive then
    return
  end

  self.timer:update(dt)

  self:move(self.position + self.velocity * dt)
end

function Shell:timeout()
  self.isAlive = false
end

function Shell:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

function Shell.collide(shell, other)
  if other.isWall then
    return 'bounce'
  elseif other.isAlive and (other.isBullet or other.isPlayer) then
    return 'touch'
  end
end

return Shell