local waves = require('data/waves')
local Vector = require('vendor.h.vector')

local Grunt = require('model.factory.grunt')
local Barrier = require('model.factory.barrier')
local Person = require('model.person')
local Hulk = require('model.factory.hulk')

local WaveManager = {
  current = 1,
  display = 1,
  worldEntities = nil,
  player = nil,
  arena = nil
}

WaveManager.__index = WaveManager

local safeDistance = {
  grunt = 100,
  hulk = 150,
  barrier = 40,
  person = 40,
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
  
  self:addWorldEntities('grunt', Grunt)
  self:addWorldEntities('barrier', Barrier)
  self:addWorldEntities('person', Person)
  self:addWorldEntities('hulk', Hulk)
end

function WaveManager:restartRound()
  self:centerPlayer()
  
  for i, entity in ipairs(self.worldEntities.list) do
    local distance = safeDistance[entity.type]

    entity:reset(self.player)

    local position = self.arena:randomPosition(entity.width, entity.height, self.player.position, distance)
    entity:place(position)
  end
  
  for i, entity in ipairs(self.worldEntities.list) do
    entity:move(entity.position)
  end
  
  self.player:reset()
end

function WaveManager:addWorldEntities(type, klass)
  local distance = safeDistance[type]
  for i = 1,self:currentWave()[type] do


    local entity
    if klass == Grunt or klass == Barrier or klass == Hulk then
      entity = klass(position, self.worldEntities)
      local position = self.arena:randomPosition(entity.width, entity.height, self.player.position, distance)
      entity:setPosition(position)
    else
      local position = self.arena:randomPosition(klass.width, klass.height, self.player.position, distance)
      entity = klass.create(position, self.worldEntities)
    end
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