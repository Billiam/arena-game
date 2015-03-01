local Throttle = require('lib.throttle')
local Bullet = require('model.factory.bullet')
local Auto = require('model.gun.auto')

local Gun = {}

Gun.mt = { __index = Gun }
Gun.__index = Gun

local none = { fire = function() end }

function Gun.none()
  return none
end

function Gun.auto()
  return Gun.create(Auto)
end

function Gun.create(type)
  local instance = {
    properties = type
  }
  
  setmetatable(instance, Gun.mt)

  if type.repeatRate and type.repeatRate > 0 then
    instance.throttle = Throttle.create(
      function(...) return instance:createShot(...) end, 
      type.repeatRate
    )
  end
  
  return instance
end

function Gun:createShot(player)
  local angle = player.angle + math.pi * 0.5 * (love.math.random() - 0.5) * (1 - self.properties.accuracy)

  return { Bullet(player:gunPosition(), angle, self.properties.speed) }
end

function Gun:fire(dt, ...)
  return self.throttle:run(dt, ...)
end

return Gun