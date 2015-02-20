local ButtonView = require('lib.gui.view.button')

local Styleable = require('lib.gui.mixin.styleable')
local Eventable = require('lib.gui.mixin.eventable')

local Focus = require('lib.gui.behavior.focus')

local defaultPadding = 10

local Button = {
  type = 'button',
  
  x = 0,
  y = 0,
  text = '',
}

Button.mt = { __index = Button }

Eventable:mixInto(Button)
Styleable:mixInto(Button)

function Button.create(data)
  local instance = data or {}
  setmetatable(instance, Button.mt)
  
  instance:importStyle(instance.style)
  instance.style = nil

  instance.height = instance.height or instance:defaultHeight()
  instance.width = instance.width or instance:defaultWidth()

  Focus.register(instance)

  return instance
end

function Button:importStyle(style)
  if style then
    if type(style) == 'table' then
      self:addStyle(unpack(style))
    else
      self:addStyle(style)
    end
  end

  self:applyStyles()
end

function Button:defaultHeight()
  local properties = self:getStyleProperties()

  local font = properties.font or love.graphics.getFont()
  local padding = properties.padding or defaultPadding

  return font:getHeight() + padding * 2
end

function Button:defaultWidth()
  local properties = self:getStyleProperties()

  local font = properties.font or love.graphics.getFont()
  local padding = properties.padding or defaultPadding

  return font:getWidth(self:getText()) + padding * 2
end

function Button:getText()
  if type(self.text) == 'function' then
    return self.text()
  else
    return self.text
  end
end

function Button:render()
  ButtonView.render(self)
end

return Button
