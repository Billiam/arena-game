local beholder = require('vendor.beholder')

local Grunt = {
  isGrunt = true,
  type = 'grunt',
  colliderType = 'grunt',
  height = 15,
  width = 15,
  isAlive = true,
  distance = 15,
  minimumStep = 0.06,
}

Grunt.__index = Grunt

function Grunt.create(position)
  local instance = {
    position = position:clone(),
    angle = 0,    
    nextStep = love.math.random() + 2,
    accumulator = 0,
    patience = 1
  }
  
  local self = setmetatable(instance, Grunt)
  
  return self
end

function Grunt:place(position)
  self.position = position
  beholder.trigger('COLLIDEUPDATE', self) 
end

function Grunt:move(position)
  self.position = position
  beholder.trigger('COLLIDEMOVE', self)
end

function Grunt:update(dt, player)
  self.accumulator = self.accumulator + dt
  
  if self.accumulator >= self.nextStep then
    self.patience = math.max(0, 1 - self.accumulator/30)
    
    self.nextStep = self.accumulator + self.minimumStep + self.patience * 0.4 + love.math.random() * self.patience * 1.2
    
    self:step(dt, player)
  end
end

function Grunt:step(dt, player)
  self:move(self.position + (player.position - self.position):normalized() * self.distance)
end

function Grunt:reset()
  self.patience = 1
  self.accumulator = 0
  self.nextStep = love.math.random() + 2
end

function Grunt.collide(grunt, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isPlayer or other.isBarrier) then
    return 'touch'
  end
end

return Grunt