local waves = require('data/waves')
local Vector = require('vendor.h.vector')

local Spheroid = require('model.factory.spheroid')
local Grunt = require('model.factory.grunt')
local Barrier = require('model.factory.barrier')
local Person = require('model.factory.person')
local Hulk = require('model.factory.hulk')
local Quark = require('model.factory.quark')

local WaveManager = {
  current = 1,
  display = 1,
  worldEntities = nil,
  player = nil,
  arena = nil
}

WaveManager.__index = WaveManager

local SafeDistance = {
  grunt = 100,
  hulk = 150,
  barrier = 40,
  person = 40,
  spheroid = 120,
  quark = 120,
}

local SpawnTypes = {
  grunt = Grunt,
  barrier = Barrier,
  person = Person,
  hulk = Hulk,
  spheroid = Spheroid,
  quark = Quark
}

local function getWave(index)
  return waves[index]
end

function WaveManager:currentWave()
  return getWave(self.current)
end

function WaveManager.create(player, arena, worldEntities)
  local instance = {
    player = player,
    arena = arena,
    worldEntities = worldEntities,
  }
  
  setmetatable(instance, WaveManager)
  
  return instance
end

function WaveManager:centerPlayer()
  self.arena:center(self.player)
end

function WaveManager:addWave()
  self.arena.visible = self:currentWave().walls
  
  self:centerPlayer()

  for name, factory in pairs(SpawnTypes) do
    self:addWorldEntities(name, factory)
  end
end

function WaveManager:restartRound()
  self:centerPlayer()

  -- Remove decorative entities (death actors, particles, etc)
  self.worldEntities:removeTransient()

  for i, entity in ipairs(self.worldEntities.list) do
    entity:reset(self.player)

    local distance = SafeDistance[entity.type] or 0
    local position = self.arena:randomPosition(entity.width, entity.height, self.player.position, distance)

    entity:place(position)
  end

  -- Move all entities to trigger collisions in new locations
  for i, entity in ipairs(self.worldEntities.list) do
    if entity.isCollidable then
      entity:move(entity.position)
    end
  end
  
  self.player:reset()
end

function WaveManager:addWorldEntities(type, klass)
  local distance = SafeDistance[type]
  for i = 1,self:currentWave()[type] do
    local entity = klass(nil, self.worldEntities)
    local position = self.arena:randomPosition(entity.width, entity.height, self.player.position, distance)
    entity.position = position

    self.worldEntities:add(entity)
  end
end

function WaveManager:waveNumber()
  return self.display
end

function WaveManager:next()
  self.display = self.display + 1
  self.current = self.current + 1
  
  if self.current > 40 then
    self.current = 21
  end
  
  self.worldEntities:clear()
end

function WaveManager:reset()
  self.display = 1
  self.current = 1
end

return WaveManager