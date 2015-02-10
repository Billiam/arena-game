local ButtonView = require('lib.gui.view.button')

local Styleable = require('lib.gui.mixin.styleable')
local Eventable = require('lib.gui.mixin.eventable')

local Focus = require('lib.gui.behavior.focus')

local Button = {
  type = 'button',
  
  x = 100,
  y = 100,
  
  index = 1,
  
  width = 100,
  height = 100,
}

Button.mt = { __index = Button }

Eventable:mixInto(Button)
Styleable:mixInto(Button)

function Button.create(parent, data)
  local instance = {}
  instance.userData = data or {}

  instance.x, instance.y = instance.userData.x, instance.userData.y

  setmetatable(instance, Button.mt)

  instance.parent = parent

  if instance.userData.style then
    if type(instance.userData.style) == 'table' then
      instance:addStyle(unpack(instance.userData.style))
    else
      instance:addStyle(instance.userData.style)
    end
  end
  
  Focus.register(instance)
  instance:applyStyles()

  return instance
end

function Button:getText()
  if type(self.userData.text) == 'function' then
    return self.userData.text()
  else
    return self.userData.text
  end
end

function Button:updateDimensions()
  self.width, self.height = self:calculateDimensions()
end

function Button:calculateDimensions()
  local properties = self:getStyleProperties()

  if self.userData.width and self.userData.height then
    return self.userData.width, self.userData.height
  end
  local width, height

  local font = properties.font or love.graphics.getFont()
  local padding = properties.padding or 10

  height = self.userData.height or (font:getHeight() + padding * 2)
  width = self.userData.width or (font:getWidth(self:getText()) + padding * 2)

  return width, height
end

function Button:render()
  ButtonView.render(self)
end

return Button
