local Geometry = require('lib.geometry')
local Resource = require('resource')
local Player = {}

function Player.render(player)
  local gunPosition = player:gunPosition()
  
  local img = Resource.image['player/firing']
  local offset = 0
  local width = 1

  if math.abs(Geometry.radianDiff(player.angle, math.pi)) >= Geometry.QUARTERCIRCLE then
    width = -1
    offset = img:getWidth()
  end

  love.graphics.draw(
    img,
    player.position.x - 9,
    player.position.y - 2,
    0,
    width,
    1,
    offset
  )

  love.graphics.setColor(255, 0, 255)
  love.graphics.circle("fill", gunPosition.x, gunPosition.y, 4, 8)
  love.graphics.setColor(255, 255, 225)
end

return Player