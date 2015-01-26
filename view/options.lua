local Resource = require('resource')
local Translator = require('lib.translate')
local Options = {}

function Options.render(menu)
  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, 50)

  love.graphics.setFont(Resource.font.noto_black[20])
  love.graphics.setColor(220, 220, 220, 255)
  love.graphics.printf(Translator.OPTIONS, 0, 20, 400, 'center')

  love.graphics.setFont(Resource.font.noto_regular[16])
  menu:setDimensions(400, 30, 300, 0, 20)
  menu:draw(0, 100)
  love.graphics.pop()
end

return Options