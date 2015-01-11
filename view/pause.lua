local Pause = {}

function Pause.render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Pause screen", 300, 300)
end

return Pause