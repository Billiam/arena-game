local Player = {}

function Player.render(player)
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle("fill", player.position.x, player.position.y, player.width, player.height)
  
  love.graphics.setColor(255, 0, 255)
  love.graphics.circle("fill", player.gunPosition.x, player.gunPosition.y, 4, 8)
end

return Player