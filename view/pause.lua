local Resource = require('resource')
local Translate = require('lib.translate')
local Pause = {}

function Pause.render(menu)
  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, math.floor(love.graphics.getHeight()/2) - 200)

  love.graphics.setColor(0, 0, 0, 100)
  love.graphics.rectangle('fill', 0, 0, 400, 200)

  love.graphics.setFont(Resource.font.noto_black[20])
  love.graphics.setColor(220, 220, 220, 255)
  love.graphics.printf(Translate.PAUSED, 0, 20, 400, 'center')

  love.graphics.setFont(Resource.font.noto_regular[16])
  menu:draw(50, 100)
  love.graphics.pop()
end

return Pause