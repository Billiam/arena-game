local Resource = require('resource')
local Title = {}

function Title.render()
  local img = Resource.image.title
  love.graphics.draw(img, (love.graphics.getWidth() - img:getWidth())/2, (love.graphics.getHeight() - img:getHeight())/2)
end

return Title