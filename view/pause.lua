local Pause = {}

function Pause.render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Pause screen", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
end

return Pause