local TypeLimiter = {}
TypeLimiter.mt = { __index = TypeLimiter }

function TypeLimiter.create(type, limit, entities)
  local instance = {
    type = type,
    limit = limit,
    entities = entities
  }
  setmetatable(instance, TypeLimiter.mt)

  return instance
end

function TypeLimiter:canAdd(count)
  count = count or 1

  return self.limit - #self.entities:type(self.type) >= count
end

function TypeLimiter:isLimited()
  return not self:canAdd()
end

return TypeLimiter