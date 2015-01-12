local Lives = require('view.lives')
local Osd = {}

function Osd.render(player)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 6, 6)
  love.graphics.setColor(255,255,255, 255)
  
  Lives.render(player)
end

return Osd