local Resource = require('resource')
local Geometry = require('lib.geometry')

local Enforcer = {
  type = 'enforcer_view'
}
Enforcer.mt = {__index = Enforcer }

function Enforcer.create()
  local instance = {
  }
  setmetatable(instance, Enforcer.mt)
  return instance
end

function Enforcer:render(enforcer)
  love.graphics.push()
  love.graphics.setColor({255, 0, 0, 255})
  love.graphics.translate(enforcer.position.x + enforcer.width / 2, enforcer.position.y + enforcer.height / 2)
  love.graphics.circle('fill', 0, 0, enforcer.width/2)

  love.graphics.setColor(0, 0, 255, 255)
--  love.graphics.line(0, 0, math.cos(enforcer.angle) * 15, math.sin(enforcer.angle) * 15)

  love.graphics.setColor(0, 255, 0, 255)
--  love.graphics.line(0, 0, enforcer.velocity.x * 5, enforcer.velocity.y * 5)

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Enforcer