local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Controller = require('lib.controller')

local Vector =  require('vendor.h.vector')
local Bump = require('vendor.bump')
local beholder = require('vendor.beholder')

local Firing = require('component.firing')
local PlayerInput = require('component.player_input')
local Health = require('component.health')

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
local CollisionResolver = require('model.collision_resolver')
local Gun = require('model.gun')
local WaveManager = require('model.wave_manager')

local waves = nil
local player = nil
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
  Game.updateInput(dt)
  Game.updatePlayer(dt)
  Game.updateEnemies(dt)
  Game.updateBullets(dt)
  Game.updateDead(dt)
  Game.updateWave(dt)
end

function Game.draw()
  PlayerView.render(player)
  BulletView.render(bullets.list)
  OSDView.render(player)
  WallView.render(arena)

  GruntView.render(enemies:type('grunt'))
  BarrierView.render(enemies:type('barrier'))
end

function Game.setup()
  local collider = Bump.newWorld()
  
  bullets = Collection.create(collider)
  enemies = Collection.create(collider)
  
  arena = Arena.create(30, collider)

  local input = PlayerInput.create(1)
  local firing = Firing.create(bullets)
  local health = Health.create()
  
  player = Player.create(Vector(200, 200), input, firing, health)
  player:setGun(Gun.auto())
  
  collider:add(player, player.position.x, player.position.y, player.width, player.height)
  
  collisionResolver = CollisionResolver.create(collider)
  collisionResolver:observe()
  
  waves = WaveManager.create(player, arena, enemies)
end

function Game.updateInput()
  if Controller.pause() then
    Gamestate.push(Resource.state.pause)
    return
  end
end

function Game.restartWave()
  waves:restartRound()
end
  
function Game.updateWave()
  if #enemies.list - #enemies:type('barrier') == 0 then
    Game.nextWave()
  end
end

function Game.nextWave()
  waves:next()
  Game.addWave()
end

function Game.addWave()
  waves:addWave()
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
  eventListeners.death = beholder.observe('PLAYERDEATH', Game.restartWave)
  eventListeners.gameEnd = beholder.observe('GAMEOVER', Game.death)
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
  
  if waves then
    waves:reset()
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