local Label = {}

function Label.render(label)
  local properties = label:getStyleProperties()

  if properties.color then
    love.graphics.setColor(unpack(properties.color))
  end

  if properties.font then
    love.graphics.setFont(properties.font)
  end
  local fontHeight = love.graphics.getFont():getHeight()

  love.graphics.printf(label:getText(), label.x, label.y + (label.height - fontHeight)/2, label.width, "center")

  love.graphics.setColor({255, 255, 255, 255})
end

return Label