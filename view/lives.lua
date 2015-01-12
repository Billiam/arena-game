local Lives = {}
Lives.__index = Lives

function Lives.render(player)
  love.graphics.print("Lives: " .. player:lives(), 300, 6)
end

return Lives