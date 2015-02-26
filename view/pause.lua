local Resource = require('resource')
local Translate = require('lib.translate')
local Pause = {}

function Pause.render(scene)
  local initialFont = love.graphics.getFont()

  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, math.floor(love.graphics.getHeight()/2) - 200)

  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.rectangle('fill', 0, 0, 400, 300)

  love.graphics.setFont(Resource.font.noto_black[24])
  love.graphics.setColor(0, 0, 0, 160)
  love.graphics.printf(Translate.PAUSED, 0, 20, 400, 'center')

  love.graphics.pop()

  love.graphics.setFont(initialFont)

  scene:render()

end

return Pause