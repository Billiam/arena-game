local TypeLimiter = require('model.type_limiter')

local limits = require('data.limit')

local no_limit = {
  isLimited = function() return false end,
  canAdd = function() return true end
}

return function(type, entities)
  return limits[type] and TypeLimiter.create(type, limits[type], entities) or no_limit
end