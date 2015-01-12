local Lives = require('view.lives')
local Wave = require('view.wave')
local Osd = {}

function Osd.render(player, waves)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 6, 6)
  love.graphics.setColor(255,255,255, 255)
  
  Lives.render(player)
  Wave.render(waves)
end

return Osd