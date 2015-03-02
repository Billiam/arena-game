local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Controller = require('lib.controller')

local Camera = require('lib.arcade_camera')

local Vector =  require('vendor.h.vector')
local Bump = require('vendor.bump')
local beholder = require('vendor.beholder')

-- models
local Collection = require('model.collection')
local WaveCollection = require('model.wave_collection')
local Arena = require('model.arena')
local Player = require('model.factory.player')
local CollisionResolver = require('model.collision_resolver')
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
  dt = dt * (Game.dtModifier or 1)

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

  for i,entity in ipairs(bullets.list) do
    entity:render()
  end

  for i,entity in ipairs(deadThings) do
    entity:render()
  end

  for i,entity in ipairs(worldEntities:zSorted(player)) do
    entity:render()
  end

  Resource.view.wall.render(arena)

  if Game.showHitboxes then
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

  player = Player(Vector(100, 100), bullets, 1)

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
  scorekeeper:save()
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