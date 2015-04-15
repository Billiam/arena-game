local Limiter = require('model.factory.limiter')

local LimiterSet = {}

LimiterSet.mt = { __index = function(self, type)
  if LimiterSet[type] then
    return LimiterSet[type]
  end

  local limiter = self:factory(type)

  rawset(self, type, limiter)

  return limiter
end}

function LimiterSet.create(entities)
  local instance = {
    entities = entities
  }

  setmetatable(instance, LimiterSet.mt)

  return instance
end

function LimiterSet:factory(type)
  return Limiter(type, self.entities)
end

return LimiterSet
