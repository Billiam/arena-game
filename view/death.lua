local Resource = require('resource')
local Translate = require('lib.translate')
local Death = {}

function Death.render()
  love.graphics.setColor(0, 0, 0, 200)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(Resource.font.pressstart2p[24])
  love.graphics.printf(Translate.GAME_OVER, 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), 'center')
end

return Death