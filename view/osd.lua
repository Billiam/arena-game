local Osd = {}

function Osd.render()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 6, 6)
  love.graphics.setColor(255,255,255, 255)
end

return Osd