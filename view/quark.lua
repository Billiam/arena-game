local Quark = {
  type = 'quark_view'
}
Quark.mt = {__index = Quark }

function Quark.create()
  local instance = {
  }
  setmetatable(instance, Quark.mt)
  return instance
end

function Quark:render(quark)
  local line = 10
  love.graphics.setLineWidth(line)
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.rectangle("line", quark.position.x + line, quark.position.y + line, quark.width - line * 2, quark.height - line * 2)
  love.graphics.setLineWidth(1)

  love.graphics.setColor(255, 255, 255, 255)
end

return Quark