local beholder = require('vendor.beholder')

local Robot = {
  isRobot = true,
  colliderType = 'grunt',
  height = 15,
  width = 15,
  isAlive = true
}

Robot.mt = { __index = Robot }
Robot.__index = Robot

function Robot.create(position)
  local instance = {
    position = position:clone(),
    angle = 0,
    
    distance = 15,
    minimumStep = 0.06,
    
    nextStep = love.math.random() + 2,
    accumulator = 0,
    patience = 1
  }
  
  local self = setmetatable(instance, Robot.mt)
  
  return self
end

function Robot:update(dt, player)
  self.accumulator = self.accumulator + dt
  
  if self.accumulator >= self.nextStep then
    self.patience = math.max(0, 1 - self.accumulator/30)
    
    self.nextStep = self.accumulator + self.minimumStep + self.patience * 0.4 + love.math.random() * self.patience * 1.2
    
    self:step(dt, player)
  end
end

function Robot:step(dt, player)
  self.position = self.position + (player.position - self.position):normalized() * self.distance
  beholder.trigger('COLLIDEMOVE', self)
end

function Robot.collide(robot, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isPlayer or other.isBarrier) then
    return 'touch'
  end
end

return Robot