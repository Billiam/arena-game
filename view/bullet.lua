local Resource = require('resource')
local anim8 = require('lib.anim8')
local img = Resource.image['bullet/sprite']
local grid = anim8.newGrid(16, 16, img:getWidth(), img:getHeight())

local Bullet = {
  type = 'bullet_view'
}
Bullet.mt = {__index = Bullet }

local Animations = {
  fire = anim8.newAnimation(img, grid('1-2', 1)),
  hit = anim8.newAnimation(img, grid('2-8', 1))
}

function Bullet.create()
  local instance = {
    fire = anim8.newPlayer(Animations.fire, 60, 'pauseAtEnd'),
    hit = anim8.newPlayer(Animations.hit, 60, 'pauseAtEnd')
  }
  instance.animation = instance.fire

  setmetatable(instance, Bullet.mt)

  return instance
end

function Bullet:update(bullet, dt)
  if not bullet.isAlive then
    self.animation = self.hit
  end

  self.animation:update(dt)
end

function Bullet:render(bullet)
  local angle = math.atan2(bullet.velocity.y, bullet.velocity.x)

  love.graphics.push()
    love.graphics.translate(bullet.position.x + bullet.width/2, bullet.position.y + bullet.height/2)
    love.graphics.rotate(angle)
    self.animation:draw(-8, -8)
  love.graphics.pop()
end

return Bullet