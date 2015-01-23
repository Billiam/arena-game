local Background = {}

function Background.render()
  love.graphics.push()
  love.graphics.setColor(220, 220, 220)
  love.graphics.rectangle("fill", 0, 0, App.width, App.height)
  love.graphics.pop()
end

return Background