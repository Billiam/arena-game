local Resource = require('resource')
local anim8 = require('vendor.anim8')
local img = Resource.image['bullet/bullet']
local grid = anim8.newGrid(16, 16, img:getWidth(), img:getHeight())

local Bullet = {
  type = 'bullet_view'
}
Bullet.mt = {__index = Bullet }

function Bullet.create()
  local instance = {
    fire = anim8.newAnimation(grid('1-2', 1), 1/60, 'pauseAtEnd'),
    hit = anim8.newAnimation(grid('2-8', 1), 1/60, 'pauseAtEnd')
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
    self.animation:draw(img, -8, -8)
  love.graphics.pop()
end

return Bullet