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
    speed = 100
  }
  
  local self = setmetatable(instance, Robot.mt)
  
  return self
end

function Robot:update(dt, player)
  self.position = self.position + (player.position - self.position):normalized() * self.speed * dt
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