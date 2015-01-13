local Timer = {}

Timer.__index = Timer

function Timer.create(timer)
  local instance = {
    timer = timer,
  }
  
  setmetatable(instance, Timer)
  
  return instance
end

function Timer:expired()
  return self.timer == nil
end

function Timer:update(dt)
  if not self.timer then
    return
  end

  self.timer = self.timer - dt
  if self.timer <= 0 then
    self.timer = nil
  end
end

function Timer:reset(time)
  self.timer = time
end

return Timer