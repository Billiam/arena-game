local Death = {}

function Death.render()
  love.graphics.setColor(0, 0, 0, 200)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("The End", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
end

return Death