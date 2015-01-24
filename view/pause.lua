local Pause = {}

function Pause.render(menu)
  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, math.floor(love.graphics.getHeight()/2) - 200)

  love.graphics.setColor(0, 0, 0, 100)
  love.graphics.rectangle('fill', 0, 0, 400, 200)

  love.graphics.setColor(220, 220, 220, 255)
  love.graphics.printf("Paused", 0, 20, 400, 'center')

  menu:draw(50, 100)
  love.graphics.pop()
end

return Pause