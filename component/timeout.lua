local cron = require('vendor.cron')
local componentName = 'Timeout'

local Timeout = {
  type = componentName
}
Timeout.mt = { __index = Timeout}

function Timeout.create(duration)
  local instance = {
    duration = duration
  }

  setmetatable(instance, Timeout.mt)

  return instance
end

function Timeout:init(entity)
  self.timer = cron.after(self.duration, self.complete, self, entity)
end

function Timeout:complete(entity)
  entity.isAlive = false
end

function Timeout:update(entity, dt)
  self.timer:update(dt)
end

return Timeout