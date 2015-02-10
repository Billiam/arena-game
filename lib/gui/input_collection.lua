local bump = require('vendor.bump')
local guid = require('lib.guid')

local InputCollection = {}

function InputCollection:create(parent)
  local instance = {
    world = bump.newWorld(),
    items = {},
    navigation = {},

    parent = parent
  }

  setmetatable(instance, {__index = InputCollection})
  return instance
end

local indexSort = function(a, b)
  return a.index ~= b.index and a.index < b.index or a.id < b.id
end

local function firstIndex(table, item)
  for i,v in ipairs(table) do
    if v.input == item then
      return i
    end
  end
end

function InputCollection:before(element)
  local index = firstIndex(self.navigation, element) or 0
  local previous = self.navigation[(index - 2) % #self.navigation + 1]

  return previous.input
end

function InputCollection:after(element)
  local index = firstIndex(self.navigation, element) or 0
  local next = self.navigation[index % #self.navigation + 1]

  return next.input
end

function InputCollection:first(x, y)
  if not (x and y) then
    return nil
  end

  local lowElement
  local lowSort

  local elements = self.world:queryPoint(x, y)

  for i,element in ipairs(elements) do
    local sort = self.items[element]
    if (not lowElement) or indexSort(sort, lowSort) then
      lowElement = element
      lowSort = sort
    end
  end

  return lowElement
end

local function removeAll(table, item)
  for i=#table,1,-1 do
    if table[i] == item then
      table.remove(table, i)
    end
  end
end

function InputCollection:remove(item)
  if self.world:hasItem(item) then
    self.world:remove(item)
  end

  removeAll(self.items, item)
  removeAll(self.navigation, item)
end

function sortFactory(item)
  return {index = item.index or 1, id = guid(), input = item}
end

function InputCollection:each()
  return pairs(self.items)
end

function InputCollection:add(item)
  item.parent = item.parent or self.parent

  self.items[item] = sortFactory(item)

  if item.index then
    table.insert(self.navigation, sortData)
    table.sort(self.navigation, indexSort)
  end

  self.world:add(item, item.x, item.y, item.width, item.height)
end

return InputCollection