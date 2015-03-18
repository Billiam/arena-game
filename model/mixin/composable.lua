local Mixin = require('lib.mixin')
local Composable = {}
setmetatable(Composable, {__index = Mixin})

function Composable:getComponents()
  self.components = self.components or {}

  return self.components
end

function Composable:add(component)
  self:getComponents()[component.type] = component

  if component.init then
    component:init(self)
  end

  return self
end

function Composable:remove(type)
  local components = self:getComponents()
  local component = components[type]

  components[type] = nil

  if component and component.destroy then
    component.destroy(self)
  end
  
  return self
end

local function call(self, method, ...)
  for name,component in pairs(self.components) do
    if component[method] then
      component[method](component, ...)
    end
  end
end

function Composable:updateComponents(...)
  call(self, 'update', ...)
end

function Composable:renderComponents(...)
  call(self, 'render', ...)
end

return Composable