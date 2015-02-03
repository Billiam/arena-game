local NameEntry = {
  DELETE = {'delete'},
  END = {'end'}
}
NameEntry.__index = NameEntry
NameEntry.mt = { 
  __index = function(entry, key)
    return NameEntry[key] or entry:value(key)
  end
}

local defaults = {
  limit = 3
}

local cycle = {}
local endCycle = {}

for i=65,90 do
  table.insert(cycle, string.char(i))
end

table.insert(cycle, NameEntry.END)
table.insert(cycle, NameEntry.DELETE)
table.insert(cycle, ' ')

table.insert(endCycle, NameEntry.END)
table.insert(endCycle, NameEntry.DELETE)

local function oneMod(value, mod)
  return (value - 1) % mod + 1
end

function NameEntry.create(input, score)
  local instance = {
    limit = defaults.limit,
    cycles = {cycle, cycle, cycle, endCycle},
    keyPositions = {1, nil, nil, nil},
    selected = 1,
    complete = false,
    
    score = score,
    input = input
  }

  setmetatable(instance, NameEntry.mt)

  return instance
end

function NameEntry:update()
  self.input:update(self)
  
  if self.complete then
    self.score[1] = self:toString()
    return self.score
  end
end

function NameEntry:toString()
  local str = {}

  for i,v in ipairs(self.keyPositions) do
    local char = self:value(i)
    if char == NameEntry.DELETE or char == NameEntry.END then
      break
    end
    
    table.insert(str, char)
  end
  
  return table.concat(str)
end

function NameEntry:cycle(index)
  return self.cycles[index]
end

function NameEntry:value(index)
  local position = self.keyPositions[index]
  local cycle = self.cycles[index]

  return cycle and position and cycle[position]
end

function NameEntry:currentValue()
  return self:value(self.selected)
end

function NameEntry:findIndex(char)
  for i,k in ipairs(self.cycles[self.selected]) do
    if k == char then
      return i
    end
  end
  
  return false
end

function NameEntry:type(char)
  if char and type(char) == 'string' then
    char = string.upper(char)
    
    local index = self:findIndex(char)
    if index then
      self:set(index)
      if self:advance() then
        self:setEnd()
      end
    end
  end
end

function NameEntry:cycleBy(amount)
  amount = amount or 1
  
  local pos = self.keyPositions[self.selected] or 0
  local letterCycle = self.cycles[self.selected]

  self:set(oneMod(pos + amount, #letterCycle))
end

function NameEntry:down()
  self:cycleBy(-1)
end

function NameEntry:up()
  self:cycleBy(1)
end

function NameEntry:advance()
  local previous = self.selected
  self.selected = math.min(self.selected + 1, self.limit + 1)
  
  return previous ~= self.selected
end

function NameEntry:next()
  self:advance()
  
  if not self:currentValue() then
    self:set(1)
  end
end

function NameEntry:delete()
  self:set(nil)
  
  if self.selected > 1 then
    self.selected = self.selected - 1
    self:set(nil)
  end
end

function NameEntry:confirm()
  local current = self:currentValue()
  if current == self.END then
    self.complete = true
  elseif current == self.DELETE then
    self:delete()
  else
    self:next()
  end
  
  return false
end

function NameEntry:setEnd()
  self:set(self:findIndex(NameEntry.END))
end

function NameEntry:set(index)
  if self.complete then
    return
  end
  
  self.keyPositions[self.selected] = index
end

return NameEntry
