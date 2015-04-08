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
  love.graphics.translate(spheroid.position.x + spheroid.width / 2, spheroid.position.y + spheroid.height / 2)

  love.graphics.setLineWidth(10)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.circle('line', 0, 0, spheroid.width/2 - 5)
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0, 0, 255, 255)

  love.graphics.setColor(0, 255, 0, 255)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Spheroid