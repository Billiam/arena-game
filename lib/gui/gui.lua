local Gui = {
  modules = {}
}

local stylesheet = {}

setmetatable(Gui, {
  __index = function(gui, key)
    if gui.modules[key] then
      return function(...)
        return gui.field(key, ...)
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

function Gui.field(type, ...)
  local field = Gui.modules[type]
  
  if not field then
    return
  end
  
  local item = field.create(...)

  return item
end

return Gui