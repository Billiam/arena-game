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
  love.graphics.setColor({220, 20, 20, 255})
  love.graphics.translate(enforcer.position.x + enforcer.width / 2, enforcer.position.y + enforcer.height / 2)
  love.graphics.circle('fill', 0, 0, enforcer.width/2)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Enforcer