local Button = {}

function Button.render(button)
  local properties = button:getStyleProperties()

  if properties.background then
    love.graphics.setColor(unpack(properties.background))
    love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)
  end

  if properties.image then
    local w,h = properties.image:getDimensions()
    love.graphics.draw(properties.image, button.x + (button.width - w)/2, button.y + (button.height - h)/2)
  end

  if properties.color then
    love.graphics.setColor(unpack(properties.color))
  end

  if properties.font then
    love.graphics.setFont(properties.font)
  end
  local fontHeight = love.graphics.getFont():getHeight()

  love.graphics.printf(button:getText(), button.x, button.y + (button.height - fontHeight)/2, button.width, "center")
  love.graphics.setColor({255, 255, 255, 255})
end

return Button