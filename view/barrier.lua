local barrier = {}

function barrier.render(list)
  love.graphics.setColor(255, 255, 0, 255)
  for i,v in ipairs(list) do
    love.graphics.rectangle("fill", v.position.x, v.position.y, v.width, v.height)
  end
  love.graphics.setColor(255,255,255,255)
end

return barrier