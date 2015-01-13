local Scorekeeper = {}
Scorekeeper.__index = Scorekeeper

function Scorekeeper.create(scoreTable)
  local instance = {
    scoreTable = scoreTable,
    counters = {},
    score = 0
  }
  setmetatable(instance, Scorekeeper)
  return instance
end

function Scorekeeper:reset()
  self:resetCounters()
  self.score = 0
end

function Scorekeeper:add(entityType)
  local entityScore = self.scoreTable[entityType]

  if type(entityScore) == 'number' then
    self.score = self.score + entityScore
    return
  end

  if not self.counters[entityType] then
    self.counters[entityType] = 0
  end

  self.counters[entityType] = self.counters[entityType] + 1

  local entityCount = math.min(#entityScore, self.counters[entityType])
  self.score = self.score + entityScore[entityCount]
end

function Scorekeeper:resetCounters()
  self.counters = {}
end

return Scorekeeper