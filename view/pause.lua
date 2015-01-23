local Pause = {}

function Pause.render()
  love.graphics.setColor(50, 50, 50, 255)
  love.graphics.printf("Pause screen", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
  love.graphics.setColor(255, 255, 255, 255)
end

return Pause