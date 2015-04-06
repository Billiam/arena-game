local Proxy = require('vendor.proxy')

local emptyReturn = {}
local noop = function() return emptyReturn end

local factories = Proxy(function(k)
  local factory = love.filesystem.load('model/factory/death/' .. k .. '.lua')
  return factory and factory() or noop
end)

return function(entity)
  return factories[entity.type](entity)
end