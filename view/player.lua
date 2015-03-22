local Geometry = require('lib.geometry')
local Resource = require('resource')
local anim8 = require('vendor.anim8')

local death_img = Resource.image['player/death']
local w, h = death_img:getWidth(), death_img:getHeight()
local death_grid = anim8.newGrid(w/9, h, w, h)

local Player = {
  type = 'player_view'
}
Player.mt = {__index = Player }

function Player.create()
  local instance = {
    death = anim8.newAnimation(death_grid('1-9', 1), 1/10, 'pauseAtEnd')
  }
  setmetatable(instance, Player.mt)
  return instance
end

function Player:reset()
  self.death:gotoFrame(1)
  self.death:resume()
end

function Player:update(player, dt)
  if not player.isAlive then
    self.death:update(dt)
  end
end

function Player:render(player)
  if player.isAlive then
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

  else
    love.graphics.push()
    love.graphics.translate(player.position.x + player.width/2, player.position.y + player.height/2)
    self.death:draw(death_img, -8, -8)
    love.graphics.pop()
  end
end

return Player