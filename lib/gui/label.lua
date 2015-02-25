local Focus = require('lib.gui.behavior.focus')
local Button = require('lib.gui.button')
local LabelView = require('lib.gui.view.label')

local Label = {}

for k,v in pairs(Button) do
  Label[k] = v
end

setmetatable(Label, {__index = Button})

Label.mt = { __index = Label }

Label.index = false
Label.type = 'label'

function Label.create(data)
  local instance = data or {}
  setmetatable(instance, Label.mt)

  instance:importStyle(instance.style)
  instance.style = nil

  instance.height = instance.height or instance:defaultHeight()
  instance.width = instance.width or instance:defaultWidth()

  Focus.register(instance)

  return instance
end

function Label:render()
  LabelView.render(self)
end

return Label
