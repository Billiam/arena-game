local waves = require('data/waves')
local Vector = require('vendor.h.vector')

local Grunt = require('model.grunt')
local Barrier = require('model.barrier')

local WaveManager = {
  current = 1,
  enemies = nil,
  player = nil,
  arena = nil
}

WaveManager.__index = WaveManager

local safeDistance = {
  grunt = 40,
  barrier = 40
}

local function getWave(index)
  return waves[index]
end

function WaveManager:currentWave()
  return getWave(self.current)
end

function WaveManager.create(player, arena, enemies)
  local instance = {
    player = player,
    arena = arena,
    enemies = enemies,
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
  
  self:addEnemies(Grunt)
  self:addEnemies(Barrier)
end

function WaveManager:restartRound()
  self:centerPlayer()
  
  for i, enemy in ipairs(self.enemies.list) do
    local distance = safeDistance[enemy.type]

    enemy:reset()
    enemy:place(self:randomPosition(distance, enemy.width, enemy.height))
  end
  
  for i, enemy in ipairs(self.enemies.list) do
    enemy:move(enemy.position)
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

function WaveManager:addEnemies(klass)
  local distance = safeDistance[klass.type]

  for i = 1,self:currentWave()[klass.type] do
    local enemy = klass.create(self:randomPosition(distance, klass.width, klass.height))
    self.enemies:add(enemy)
  end
end

function WaveManager:next()
  self.current = self.current + 1
  
  if self.current > 40 then
    self.current = 21
  end
  
  self.enemies:clear()
end

function WaveManager:reset()
  self.current = 1
end

return WaveManager