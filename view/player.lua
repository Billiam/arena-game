local Player = {}

function Player.render(player)
  local gunPosition = player:gunPosition()
  
  love.graphics.setColor(0, 255, 255, 255)
  love.graphics.rectangle("fill", player.position.x, player.position.y, player.width, player.height)
  
  love.graphics.setColor(255, 0, 255)
  love.graphics.circle("fill", gunPosition.x, gunPosition.y, 4, 8)
  love.graphics.setColor(255,255,255,255)
end

return Player