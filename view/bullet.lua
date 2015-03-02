local Bullet = {
  type = 'bullet_view'
}
Bullet.mt = {__index = Bullet }

function Bullet.create()
  local instance = {}
  setmetatable(instance, Bullet.mt)
  return instance
end

function Bullet:render(bullet)
  if bullet.isAlive then
    love.graphics.setColor(255, 0, 0, 255)
  else
    love.graphics.setColor(255, 0, 0, 75)
  end

  love.graphics.circle("fill", bullet.position.x, bullet.position.y, bullet.width)
  love.graphics.setColor(255,255,255,255)
end

return Bullet