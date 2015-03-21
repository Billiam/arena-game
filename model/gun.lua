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

function Gun.create(type)
  local instance = {
    properties = type,
    lastFire = 0,
    limit = 4
  }
  
  setmetatable(instance, Gun.mt)
  
  return instance
end

function Gun:createShot(player)
  local angle = player.angle + math.pi * 0.5 * (love.math.random() - 0.5) * (1 - self.properties.accuracy)

  return { Bullet(player:gunPosition(), angle, self.properties.speed) }
end

function Gun:fire(dt, player, activeBullets)
  if self.lastFire + dt >= self.properties.repeatRate and activeBullets < self.limit then
    self.lastFire = 0
    return self:createShot(player)
  end

  self.lastFire = self.lastFire + dt
end

return Gun