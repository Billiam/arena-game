local Resource = require('resource')
local Translate = require('lib.translate')
local Options = {}

function Options.render(menu)
  Resource.view.background.render(love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, 50)

  love.graphics.setFont(Resource.font.noto_black[20])
  love.graphics.setColor(50, 50, 50, 255)
  love.graphics.printf(Translate.OPTIONS, 0, 20, 400, 'center')

  menu:setDimensions(400, 30, 300, 0, 20)
  menu:draw(0, 100, {39, 39, 39, 255}, {39, 39, 39, 255}, {223, 243, 219})
  love.graphics.pop()
end

return Options