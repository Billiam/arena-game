local Proxy = require('vendor.proxy')

local emptyReturn = {}
local noop = function() return emptyReturn end

local factories = Proxy(function(k)
  return love.filesystem.load('model/factory/death/' .. k .. '.lua')() or noop
end)

return function(entity)
  return factories[entity.type](entity)
end