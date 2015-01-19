local Throttle = {}

Throttle.__index = Throttle

function Throttle.create(callback, speed)
  local instance = {
    timer = 0,
    speed = speed,
    callback = callback
  }
  
  setmetatable(instance, Throttle)

  return instance
end

function Throttle:reset()
  self.timer = 0
end

function Throttle:run(dt, ...)
  self.timer = self.timer + dt

  if self.timer >= self.speed then
    self.timer = 0

    return self.callback(...)
  end
end

return Throttle