local Input = require('lib.input')
local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Controller = require('lib.controller')

local Camera = require('lib.arcade_camera')

local Vector =  require('vendor.h.vector')
local Bump = require('vendor.bump')
local beholder = require('vendor.beholder')

local Firing = require('component.firing')
local PlayerInput = require('component.player_input')
local Health = require('component.health')

-- models
local Collection = require('model.collection')
local WaveCollection = require('model.wave_collection')
local Arena = require('model.arena')
local Player = require('model.player')
local CollisionResolver = require('model.collision_resolver')
local Gun = require('model.gun')
local WaveManager = require('model.wave_manager')
local Scorekeeper = require('model.scorekeeper')

-- data
local ScoreTable = require('data.score')

local camera = nil
local waves = nil
local scorekeeper = nil
local player = nil
local collisionResolver = nil
local bullets = nil
local worldEntities = nil
local arena = nil

local deadThings = {}
local eventListeners = {}

local debug = {
  showHitboxes = false,
  dtModifier = 1
}

local Game = {
  name = 'game'
}
setmetatable(Game, {__index = State})

function Game.enter()
  State.enter()

  Game.cleanup()
  Game.setup()
  Game.registerListeners()
  Game.addWave()
end

function Game.update(dt)
  dt = dt * debug.dtModifier

  Game.updateInput(dt)
  Game.updatePlayer(dt)
  Game.updateEntities(dt)
  Game.updateBullets(dt)
  Game.updateDead(dt)
  Game.updateWave(dt)
end

function Game.draw()
  camera:attach()

  Resource.view.background.render()
  Resource.view.bullet.render(bullets.list)

  for i,entity in ipairs(worldEntities:zSorted(player)) do
    Resource.view[entity.type].render(entity)
  end

  Resource.view.wall.render(arena)

  if debug.showHitboxes then
    Resource.view.hitbox.render(player)
    Game.drawHitboxes(worldEntities:type('grunt'))
  end

  camera:detach()

  Resource.view.osd.render(player, waves, scorekeeper.score)
end

function Game.drawHitboxes(collection)
  for i,entity in ipairs(collection) do
    Resource.view.hitbox.render(entity)
  end
end

function Game.setup()
  camera = Camera.create(App.width, App.height)
  camera:init()

  local collider = Bump.newWorld()
  
  bullets = Collection.create(collider)
  worldEntities = WaveCollection.create(collider)

  arena = Arena.create(App.width, App.height, 15, collider)

  local input = PlayerInput.create(1)
  local firing = Firing.create(bullets)
  local health = Health.create()
  
  player = Player.create(Vector(100, 100), input, firing, health)
  player:setGun(Gun.auto())

  collider:add(player, player.position.x, player.position.y, player.width, player.height)
  
  collisionResolver = CollisionResolver.create(collider)
  collisionResolver:observe()
  
  waves = WaveManager.create(player, arena, worldEntities)
  scorekeeper = Scorekeeper.create(ScoreTable)
end

function Game.updateInput()
  if Controller.pause() then
    Gamestate.push(Resource.state.pause)
    return
  end

  if App.development then
    Game.debugInput()
  end
end

function Game.debugInput()
  if Input.key.wasClicked('f1') then
    Game.nextWave()
  end

  if Input.key.wasClicked('f2') then
    Game.restartWave()
  end

  if Input.key.wasClicked('f3') then
    debug.dtModifier = debug.dtModifier == 1 and 0 or 1
  end

  if Input.key.wasClicked('f5') then
    debug.showHitboxes = not debug.showHitboxes
  end
end

function Game.restartWave()
  scorekeeper:resetCounters()
  waves:restartRound(player)
end

function Game.updateWave()
  if worldEntities:roundComplete() then
    Game.nextWave()
  end
end

function Game.nextWave()
  scorekeeper:resetCounters()
  waves:next()

  Game.addWave()
end

function Game.addWave()
  waves:addWave()
end

function Game.updateEntities(dt)
  worldEntities:update(dt, player)
end

local function removeDead(collection)
  local dead = collection:removeDead()
  
  for i,n in ipairs(dead) do
    table.insert(deadThings, n)
  end
end

function Game.updateDead(dt)
  removeDead(worldEntities)
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

function Game.kill(entity)
  scorekeeper:add(entity.type)
end

function Game.rescue(person)
  scorekeeper:add('person')
end

function Game.registerListeners()
  eventListeners.death = beholder.observe('PLAYERDEATH', Game.restartWave)
  eventListeners.gameEnd = beholder.observe('GAMEOVER', Game.death)
  eventListeners.kill = beholder.observe('KILL', Game.kill)
  eventListeners.rescue = beholder.observe('RESCUE', Game.rescue)
end

function Game.resize(x,y)
  --update camera
  camera:resize(x,y)
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
  
  if scorekeeper then
    scorekeeper:reset()
  end

  Game.unregisterListeners()
end

return Game