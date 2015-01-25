local Translate = require('lib.translate')
local Lives = {}
Lives.__index = Lives

function Lives.render(player)
  love.graphics.print(Translate.LIVES .. ": " .. player:lives(), 300, 6)
end

return Lives