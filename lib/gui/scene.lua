local gui = require('lib.gui.gui')
local InputCollection = require('lib.gui.input_collection')

local Scene = {
  type = 'scene'
}

local Dir = {
  RIGHT = 'right',
  DOWN = 'down',
  ROw = 'row'
}

Scene.mt = {
  __index = function(scene, key)
    return Scene[key] or (gui.modules[key] and
        function(scene, options)
          return scene:createField(key, options)
      end)
  end
}

function Scene.create()
  local instance = {
    inputIndex = 0
  }

  instance.inputCollection = InputCollection.create(instance)

  setmetatable(instance, Scene.mt)
  
  return instance
end

function Scene:createField(key, options)
  local field = gui.field(key, options)
  if not field then
    error(field)
  end

  self:add(field)
  return field
end

local function setIndex(scene, item)
  if item.index == null then
    scene.inputIndex = scene.inputIndex + 1
    item.index = scene.inputIndex
  end
end

local function setPosition(scene, grow, item)
  if not scene.previousElement or grow == false then
    return
  end

  if grow == Dir.RIGHT then
    item.x = item.x + scene.previousElement.width + scene.previousElement.x
    item.y = item.y + scene.previousElement.y
  elseif grow == Dir.DOWN then
    item.x = item.x + scene.previousElement.x
    item.y = item.y + scene.previousElement.height + scene.previousElement.y
  elseif grow == Dir.ROW then
    item.x = item.x + scene.rowElement.x
    item.y = item.y + scene.previousElement.height + scene.previousElement.y
  end
end

function Scene:add(item, grow)
  setPosition(self, grow, item)
  setIndex(self, item)

  self.previousElement = item

  if not self.rowElement or grow == Dir.ROW then
    self.rowElement = item
  end

  self.inputCollection:add(item)

  return self
end

function Scene:right(item)
  return self:add(item, Dir.RIGHT)
end

function Scene:down(item)
  return self:add(item, Dir.DOWN)
end

function Scene:row(item)
  return self:add(item, Dir.ROW)
end

function Scene:render()
  for element in self.inputCollection:each() do
    if element.render then
      element:render()
    end
  end

  self:resetRender()
end

function Scene:resetRender()
  love.graphics.setColor({255, 255, 255, 255})
end

function Scene:setHoverIndex(index)
  local newElement = self.inputCollection:atIndex(index)
  if newElement then
    self:setHover(newElement)
  end
end

function Scene:hoverIndex()
  return self.inputCollection:index(self.hover)
end

function Scene:previous()
  self:setHover(self.inputCollection:before(self.hover))
end

function Scene:next()
  self:setHover(self.inputCollection:after(self.hover))
end

function Scene:activate()
  if self.hover then
    self:setFocus(self.hover)
  end
end

function Scene:selectionNext()
  if self.hover then
    self.hover:trigger('next')
  end
end

function Scene:selectionPrevious()
  if self.hover then
    self.hover:trigger('previous')
  end
end

function Scene:mouseMove(x,y)
  local element = self.inputCollection:first(x, y)
  if element then
    self:setHover(element)
  end
end

function Scene:mouseDown(x,y)
  self:setFocus(self.inputCollection:first(x, y))
end

function Scene:setHover(element)
  local previousHover = self.hover
  self.hover = element

  if self.hover and self.hover ~= previousHover then
    if previousHover then
      previousHover:trigger('leave')
    end

    self.hover:trigger('hover')
  end
end

function Scene:setFocus(element)
  local previousActive = self.focus
  self.focus = element

  if self.focus then
    self.focus:trigger('focus')
  end

  if previousActive and self.focus ~= previousActive then
    previousActive:trigger('blur')
  end
end

return Scene