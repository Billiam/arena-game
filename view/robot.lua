local Robot = {}

function Robot.render(robots)
  love.graphics.setColor(255, 0, 0, 255)

  for i,robot in ipairs(robots) do
    love.graphics.rectangle("fill", robot.position.x, robot.position.y, robot.width, robot.height)
  end
  
  love.graphics.setColor(255,255,255,255)
end

return Robot