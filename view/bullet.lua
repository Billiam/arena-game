local bullet = {}

function bullet.render(list)
  love.graphics.setColor(255, 0, 0, 150)
  for i,v in ipairs(list) do
    love.graphics.circle("fill", v.position.x, v.position.y, v.width)
  end
    love.graphics.setColor(255,255,255,255)
end

return bullet