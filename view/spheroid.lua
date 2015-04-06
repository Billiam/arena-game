local Resource = require('resource')
local Geometry = require('lib.geometry')

local Spheroid = {
  type = 'spheroid_view'
}
Spheroid.mt = {__index = Spheroid }

function Spheroid.create()
  local instance = {
  }
  setmetatable(instance, Spheroid.mt)
  return instance
end

function Spheroid:render(spheroid)
  if spheroid.hidden then
    return
  end

  love.graphics.push()
  love.graphics.setColor({255, 0, 0, 255})
  love.graphics.translate(spheroid.position.x + spheroid.width / 2, spheroid.position.y + spheroid.height / 2)
  love.graphics.circle('fill', 0, 0, spheroid.width/2)

  love.graphics.setColor(0, 0, 255, 255)
--  love.graphics.line(0, 0, math.cos(spheroid.angle) * 15, math.sin(spheroid.angle) * 15)

  love.graphics.setColor(0, 255, 0, 255)
--  love.graphics.line(0, 0, spheroid.velocity.x * 5, spheroid.velocity.y * 5)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Spheroid