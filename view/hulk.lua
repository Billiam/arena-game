local Hulk = {}

function Hulk.render(hulks)
  love.graphics.setColor(0, 255, 0, 255)

  for i,hulk in ipairs(hulks) do
    love.graphics.rectangle("fill", hulk.position.x, hulk.position.y, hulk.width, hulk.height)
  end
  
  love.graphics.setColor(255,255,255,255)
end

return Hulk