local Resource = require('resource')
local Translate = require('lib.translate')
local Options = {}

function Options.render(scene)
  Resource.view.background.render(love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.push()
  love.graphics.translate(math.floor(love.graphics.getWidth()/2) - 200, 50)

  love.graphics.setFont(Resource.font.noto_black[24])
  love.graphics.setColor(50, 50, 50, 255)
  love.graphics.printf(Translate.OPTIONS, 0, 20, 400, 'center')

  love.graphics.pop()
  scene:render()
end

return Options