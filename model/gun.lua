local beholder = require('vendor.beholder')
local Bullet = require('model.factory.bullet')
local Auto = require('model.gun.auto')

local Gun = {}

Gun.mt = { __index = Gun }
Gun.__index = Gun

local none = { fire = function() end }

function Gun.none()
  return none
end

function Gun.auto(...)
  return Gun.create(Auto, ...)
end

function Gun.create(type, entityLimiter)
  local instance = {
    properties = type,
    timer = 0,
    entityLimiter = entityLimiter
  }
  
  setmetatable(instance, Gun.mt)
  
  return instance
end

function Gun:createShot(player)
  local angle = player.angle + math.pi * 0.5 * (love.math.random() - 0.5) * (1 - self.properties.accuracy)

  return { Bullet(player:gunPosition(), angle, self.properties.speed) }
end

function Gun:update(dt)
  self.timer = self.timer + dt
end

function Gun:fire(player)
  if self.timer >= self.properties.repeatRate and self.entityLimiter.bullet:canAdd() then
    self.timer = 0

    local bullets = self:createShot(player)
    local kick = Vector(0,0)

    for i,bullet in ipairs(bullets) do
      beholder.trigger('SPAWN', bullet)

      kick = kick + bullet.velocity:rotated(math.pi) * bullet.mass * 0.2
    end

    if kick:len2() then
      player:move(player.position + kick)
    end
  end
end

return Gun