local Button = {}

function Button.render(button)
  local properties = button:getStyleProperties()

  if properties.background then
    love.graphics.setColor(unpack(properties.background))
  end

  love.graphics.rectangle('fill', button.x, button.y, button.width, button.height)

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