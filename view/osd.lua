local Lives = require('view.lives')
local Wave = require('view.wave')
local Score = require('view.score')
local Osd = {}

function Osd.render(player, waves, score)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 6, 6)
  love.graphics.setColor(255,255,255, 255)
  
  Lives.render(player)
  Wave.render(waves)
  Score.render(score)
end

return Osd