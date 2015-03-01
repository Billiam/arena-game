local Collidable = require('model.mixin.collidable')
local Vector = require('vendor.h.vector')

local Barrier = {
  isBarrier = true,
  colliderType = 'barrier',
  type = 'barrier',
  isAlive = true,
  width = 15,
  height = 15
}

Barrier.__index = Barrier

Collidable:mixInto(Barrier)

function Barrier.create(position)
  local instance = {
    position = Vector.new(0, 0),
    components = {}
  }
  
  setmetatable(instance, Barrier)
  
  return instance
end

function Barrier:setPosition(position)
  self.position = position
end

function Barrier:add(component)
  self.components[component.type] = component

  return self
end

function Barrier:render()
  for type,component in pairs(self.components) do
    if component.render then
      component:render(self)
    end
  end
end


function Barrier:update() end
function Barrier:reset() end

return Barrier