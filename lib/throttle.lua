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

function Throttle:run(...)
  local time = love.timer.getTime()
  
  if self.timer + self.speed < time then
    local output = self.callback(...)
    self.timer = time
    return output
  end
end

return Throttle