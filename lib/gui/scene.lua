local gui = require('lib.gui.gui')
local InputCollection = require('lib.gui.input_collection')

local Scene = {}

Scene.mt = {
  __index = function(scene, key)
    return Scene[key] or (gui.modules[key] and function(...) return scene:createField(key, ...) end)
  end
}

function Scene.create()
  local instance = {}

  instance.inputCollection = InputCollection.create(instance)

  setmetatable(instance, Scene.mt)
  
  return instance
end

function Scene:createField(key, ...)
  local field = gui.field(key, ...)

  if not field then
    error(field)
  end

  if field then
    self:add(field)
    return field
  end
end

function Scene:add(item)
  self.inputCollection:add(item)
end

function Scene:remove(item)
  self.inputCollection:remove(item)
end

function Scene:render()
  for element in self.inputCollection:each() do
    element:render()
  end
end

function Scene:previous()
  self:setHover(self.inputCollection:before(self.hover))
end

function Scene:next()
  self:setHover(self.inputCollection:after(self.hover))
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