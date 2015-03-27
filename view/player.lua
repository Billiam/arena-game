local Geometry = require('lib.geometry')
local Resource = require('resource')
local anim8 = require('lib.anim8')

--animation resources
local sprite = Resource.image['player/sprite']
local w, h = sprite:getWidth(), sprite:getHeight()
local grid = anim8.newGrid(w/14, h/3, w, h)

local death = anim8.newAnimation(
  sprite,
  grid('1-' .. 13, 1),
  {
    ['1-6'] = 1,
    [7] = 7,
    ['8-13'] = 1.5,
  }
)
local walk = anim8.newAnimation(sprite, grid(1, 2))

local Player = {
  type = 'player_view'
}
Player.mt = {__index = Player }

function Player.create()
  local instance = {
    death = anim8.newPlayer(death, 12, 'pauseAtEnd'),
    walk = anim8.newPlayer(walk, 1)
  }
  instance.animation = instance.walk

  setmetatable(instance, Player.mt)
  return instance
end

function Player:reset()
  self.animation = self.walk

  -- TODO Cleanup
  self.death:gotoFrame(1)
  self.death:resume()
  self.walk:gotoFrame(1)
  self.walk:resume()
end

function Player:update(player, dt)
  if not player.isAlive then
    self.animation = self.death
  end

  self.animation:update(dt)
end

function Player:render(player)
  local flipped = false
  --TODO: Abstract offsets
  local offset = 25

  if math.abs(Geometry.radianDiff(player.angle, math.pi)) >= Geometry.QUARTERCIRCLE then
    flipped = true
    offset = 12
  end

  love.graphics.push()
  love.graphics.translate(player.position.x + player.width/2, player.position.y + player.height/2)
  self.animation.flippedH = flipped
  self.animation:draw(-offset, -14)
  love.graphics.pop()
end

return Player