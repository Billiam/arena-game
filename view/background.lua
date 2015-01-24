local Background = {}

function Background.render(width, height)
  width = width or App.width
  height = height or App.height

  love.graphics.setColor(220, 220, 220)
  love.graphics.rectangle("fill", 0, 0, width, height)
  love.graphics.setColor(255, 255, 255, 255)
end

return Background