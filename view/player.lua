local Geometry = require('lib.geometry')
local Resource = require('resource')
local anim8 = require('lib.anim8')

--animation resources
local sprite = Resource.image['player/sprite']
local w, h = sprite:getWidth(), sprite:getHeight()
local grid = anim8.newGrid(w/13, h/3, w, h)

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
    anim = {
      death = anim8.newPlayer(death, 12, 'pauseAtEnd'),
      walk = anim8.newPlayer(walk, 1)
    }
  }
  instance.animation = instance.anim.walk

  setmetatable(instance, Player.mt)
  return instance
end

function Player:init(player)
  if player.isAlive then
    self.animation = self.anim.walk
  else
    self.animation = self.anim.death
  end
end

function Player:reset()
  self.animation = self.anim.walk

  for i,v in pairs(self.anim) do
    v:gotoFrame(1)
    v:resume()
  end
end

function Player:update(player, dt)
  if not player.isAlive then
    self.animation = self.anim.death
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