local Barrier = {
  type = 'barrier_view'
}
Barrier.mt = {__index = Barrier }

function Barrier.create()
  local instance = {}
  setmetatable(instance, Barrier.mt)
  return instance
end

function Barrier:render(barrier)
  if barrier.isAlive then
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.rectangle("fill", barrier.position.x, barrier.position.y, barrier.width, barrier.height)
  else
    love.graphics.setColor(255, 255, 0, 120)
    love.graphics.rectangle("fill", barrier.position.x, barrier.position.y, barrier.width/2, barrier.height/2)
  end

  love.graphics.setColor(255,255,255,255)
end

return Barrier