local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Controller = require('lib.controller')

local Vector =  require('vendor.h.vector')
local Bump = require('vendor.bump')
local beholder = require('vendor.beholder')

local Firing = require('component.firing')
local PlayerInput = require('component.player_input')

-- views
local BulletView = require('view.bullet')
local BarrierView = require('view.barrier')
local PlayerView = require('view.player')
local OSDView = require('view.osd')
local GruntView = require('view.grunt')
local WallView = require('view.wall')

-- models
local Collection = require('model.collection')
local Arena = require('model.arena')
local Player = require('model.player')
local Robot = require('model.robot')
local Barrier = require('model.barrier')
local CollisionResolver = require('model.collision_resolver')
local Gun = require('model.gun')

local player = nil
local collider = nil
local collisionResolver = nil
local bullets = nil
local enemies = nil
local arena = nil

local deadThings = {}
local eventListeners = {}

local Game = {
  name = 'game'
}

setmetatable(Game, {__index = State})

function Game.update(dt)
  if Controller.pause() then
    Gamestate.push(Resource.state.pause)
    return
  end
  
  Game.updatePlayer(dt)
  Game.updateEnemies(dt)
  Game.updateBullets(dt)
  Game.updateDead(dt)
end

function Game.draw()
  PlayerView.render(player)
  BulletView.render(bullets.list)
  OSDView.render()
  WallView.render(arena.walls.list)

  GruntView.render(enemies:type('grunt'))
  BarrierView.render(enemies:type('barrier'))
end

function Game.setup()
  collider = Bump.newWorld()
  
  bullets = Collection.create(collider)
  enemies = Collection.create(collider)

  local input = PlayerInput.create(1)
  local firing = Firing.create(bullets)
  
  player = Player.create(input, firing, Vector(256,256))
  player:setGun(Gun.auto())
  
  collider:add(player, player.position.x, player.position.y, player.width, player.height)
    
  collisionResolver = CollisionResolver.create(collider)
  collisionResolver:observe('COLLIDEMOVE')
end

function Game.addWave()
  local wallInset = 30
  arena = Arena.create(wallInset, collider)
 
  player.position = Vector((arena.width - player.width)/2 + arena.position.x, (arena.height - player.height)/2 + arena.position.x)
  collider:move(player, player.position.x, player.position.y)
  
  for i = 1,15 do
    local position
    repeat
      position = Vector(
        love.math.random() * (arena.width - Robot.width) + arena.position.x,
        love.math.random() * (arena.height - Robot.height) + arena.position.y
      )
    until position:dist(player.position) > 100
    enemies:add(Robot.create(position))
  end
  
  for i = 1,5 do
    local position
    repeat
      position = Vector(
        love.math.random() * (arena.width - 10) + arena.position.x,
        love.math.random() * (arena.height - 10) + arena.position.y
      )
    until position:dist(player.position) > 10
    enemies:add(Barrier.create(position, 10, 10))
  end
end

function Game.updateEnemies(dt)
  for i,enemy in ipairs(enemies.list) do
    enemy:update(dt, player)
  end
end

local function removeDead(collection)
  local dead = collection:removeDead()
  
  for i,n in ipairs(dead) do
    table.insert(deadThings, n)
  end
end

function Game.updateDead(dt)
  removeDead(enemies)
  removeDead(bullets)
end

function Game.updateBullets(dt)
  for i,bullet in ipairs(bullets.list) do
    bullet:update(dt)
  end
end

function Game.updatePlayer(dt)
  player:update(dt)
end

function Game.death(player, cause)
  Gamestate.push(Resource.state.death)
end

function Game.registerListeners()
  eventListeners['death'] = beholder.observe('PLAYERDEATH', Game.death)
end

function Game.unregisterListeners()
  for name, id in pairs(eventListeners) do
    beholder.stopObserving(id)
  end
end

function Game.cleanup()
  if collisionResolver then
    collisionResolver:clear()
  end
  Game.unregisterListeners()
end

function Game.enter()
  State.enter()
  Game.cleanup()
  Game.setup()
  Game.registerListeners()
  Game.addWave()
end

return Game