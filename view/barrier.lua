local  Barrier = {}

function Barrier.render(barrier)
  love.graphics.setColor(255, 255, 0, 255)
  love.graphics.rectangle("fill", barrier.position.x, barrier.position.y, barrier.width, barrier.height)
  love.graphics.setColor(255,255,255,255)
end

return Barrier