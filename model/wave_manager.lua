local waves = require('data/waves')
local Vector = require('vendor.h.vector')

local Grunt = require('model.grunt')
local Barrier = require('model.barrier')
local Person = require('model.person')

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
  barrier = 40,
  person = 40
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
  -- center player in playable area 
  local playerPosition = Vector(
    (self.arena.width - self.player.width)/2 + self.arena.position.x, 
    (self.arena.height - self.player.height)/2 + self.arena.position.x
  )
  self.player:place(playerPosition)
end

function WaveManager:addWave()
  self.arena.visible = self:currentWave().walls
  
  self:centerPlayer()
  
  self:addWorldEntities(Grunt)
  self:addWorldEntities(Barrier)
  self:addWorldEntities(Person)
end

function WaveManager:restartRound()
  self:centerPlayer()
  
  for i, entity in ipairs(self.worldEntities.list) do
    local distance = safeDistance[entity.type]

    entity:reset()
    entity:place(self:randomPosition(distance, entity.width, entity.height))
  end
  
  for i, entity in ipairs(self.worldEntities.list) do
    entity:move(entity.position)
  end
  
  self.player:reset()
end

function WaveManager:randomPosition(distance, width, height)
  local position
  repeat
    position = Vector(
      love.math.random() * (self.arena.width - width) + self.arena.position.x,
      love.math.random() * (self.arena.height - height) + self.arena.position.y
    )
  until position:dist(self.player.position) > distance

  return position
end

function WaveManager:addWorldEntities(klass)
  local distance = safeDistance[klass.type]
  for i = 1,self:currentWave()[klass.type] do
    local entity = klass.create(self:randomPosition(distance, klass.width, klass.height))
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