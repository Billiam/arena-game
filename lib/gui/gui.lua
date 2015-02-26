local Gui = {
  modules = {}
}

local stylesheet = {}

setmetatable(Gui, {
  __index = function(gui, key)
    if gui.modules[key] then
      return function(gui, options)
        return gui.field(key, options)
      end
    end
  end
})

function Gui.register(type, module)
  Gui.modules[type] = module
end

function Gui.setStylesheet(styles)
  stylesheet = styles
end

function Gui.getStylesheet()
  return stylesheet
end

function Gui.field(type, options)
  local field = Gui.modules[type]

  if not field then
    error(field .. ' is not a valid field')
    return
  end

  local item = field.create(options)

  return item
end

return Gui