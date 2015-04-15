local Geometry = require('lib.geometry')

local Shell = {
  type = 'shell_view'
}
Shell.mt = {__index = Shell }

function Shell.create()
  local instance = {
  }

  setmetatable(instance, Shell.mt)

  return instance
end

function Shell:render(shell)
  love.graphics.push()
    love.graphics.translate(shell.position.x + shell.width/2, shell.position.y + shell.height/2)
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.rectangle('fill', -shell.width/2, -shell.height/2, shell.width, shell.height)
  love.graphics.pop()

  love.graphics.setColor(255, 255, 255, 255)
end

return Shell