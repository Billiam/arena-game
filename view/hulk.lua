local Hulk = {}

function Hulk.render(hulk)
  love.graphics.setColor(0, 255, 0, 255)

  love.graphics.rectangle("fill", hulk.position.x, hulk.position.y, hulk.width, hulk.height)
  love.graphics.setColor(255,255,255,255)
end

return Hulk