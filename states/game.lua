local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Controller = require('lib.controller')

local Camera = require('lib.arcade_camera')

local Vector =  require('vendor.h.vector')
local Bump = require('vendor.bump')
local beholder = require('vendor.beholder')
local cron = require('vendor.cron')

-- models
local Collection = require('model.collection')
local WaveCollection = require('model.wave_collection')
local Arena = require('model.arena')
local Player = require('model.factory.player')
local DeathFactory = require('model.factory.death')

local CollisionResolver = require('model.collision_resolver')
local WaveManager = require('model.wave_manager')
local Scorekeeper = require('model.scorekeeper')

local EntityLimiter = require('model.limiter_set')

-- data
local ScoreTable = require('data.score')

local camera 
local waves 
local scorekeeper 
local player 
local collisionResolver 
local worldEntities
local arena 
local deathManager
local entityLimiter

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

  Game.updateTimers(dt)
  Game.updateInput(dt)
  Game.updatePlayer(dt)
  Game.updateEntities(dt)
  Game.updateDead(dt)
  Game.updateWave(dt)
end

function Game.updateTimers(dt)
  if Game.timer then
    Game.timer:update(dt)
  end
end

function Game.draw()
  camera:attach()

  Resource.view.background.render()

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
  
  worldEntities = WaveCollection.create(collider)

  entityLimiter = EntityLimiter.create(worldEntities)

  arena = Arena.create(App.width, App.height, 15, collider)

  player = Player(worldEntities, 1, entityLimiter)
  player.position = Vector(100, 100)

  collider:add(player, player.position.x, player.position.y, player.width, player.height)
  
  collisionResolver = CollisionResolver.create(collider)
  collisionResolver:observe()
  
  waves = WaveManager.create(player, arena, worldEntities, entityLimiter)
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
  collection:removeDead()
end

function Game.updateDead(dt)
  removeDead(worldEntities)
end

function Game.updatePlayer(dt)
  player:update(dt)
end

function Game.death(player, cause)
  scorekeeper:save()

  if not Game.timer then
    Game.timer = cron.after(2, function()
      Gamestate.push(Resource.state.death)
    end)
  end
end

function Game.kill(entity)
  scorekeeper:add(entity.type)

  local spawnedElements = DeathFactory(entity)
  for i,element in ipairs(spawnedElements) do
    worldEntities:add(element)
  end
end

function Game.spawn(entity)
  worldEntities:add(entity)
end

function Game.rescue(person)
  scorekeeper:add('person')
end

function Game.registerListeners()
  eventListeners.death = beholder.observe('PLAYERDEATH', Game.playerDied)
  eventListeners.gameEnd = beholder.observe('GAMEOVER', Game.death)
  eventListeners.kill = beholder.observe('KILL', Game.kill)
  eventListeners.spawn = beholder.observe('SPAWN', Game.spawn)
  eventListeners.rescue = beholder.observe('RESCUE', Game.rescue)
end

function Game.resize(x,y)
  --update camera
  camera:resize(x,y)
end

function Game.playerDied()
  if not Game.timer then
    Game.timer = cron.after(2.5, function()
      Game.timer = nil
      Game.restartWave()
    end)
  end
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

  Game.timer = nil

  Game.unregisterListeners()
end

return Game