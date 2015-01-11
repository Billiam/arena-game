local Death = {}

function Death.render()
  love.graphics.setColor(0, 0, 0, 200)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("The end", 300, 300)
end

return Death