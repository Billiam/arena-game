local Title = {}

function Title.render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Title screen", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
end

return Title