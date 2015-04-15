local Resource = require('resource')
local Geometry = require('lib.geometry')

local Tank = {
  type = 'tank_view'
}
Tank.mt = {__index = Tank }

function Tank.create()
  local instance = {
  }
  setmetatable(instance, Tank.mt)
  return instance
end

function Tank:render(tank)
  love.graphics.setColor(150, 0, 255, 255)
  love.graphics.rectangle('fill', tank.position.x, tank.position.y, tank.width, tank.height)
  love.graphics.setColor(255, 255, 255, 255)
end

return Tank