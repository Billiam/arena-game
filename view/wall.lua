local Wall = {}

function Wall.render(arena)
  if not arena.visible then
    return
  end
  
  love.graphics.setColor(0, 255, 255, 255)
  for i,wall in ipairs(arena.walls.list) do
    love.graphics.rectangle("line", wall.position.x, wall.position.y, wall.width, wall.height)
  end
  love.graphics.setColor(255, 255, 255, 255)
end

return Wall