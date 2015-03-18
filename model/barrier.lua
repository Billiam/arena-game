local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')
local Vector = require('vendor.h.vector')
local beholder = require('vendor.beholder')

local Barrier = {
  isBarrier = true,
  colliderType = 'barrier',
  type = 'barrier',
  isAlive = true,
  width = 15,
  height = 15
}

Barrier.__index = Barrier

Composable:mixInto(Barrier)
Collidable:mixInto(Barrier)

function Barrier.create(position)
  local instance = {
    position = Vector.new(0, 0),
  }
  
  setmetatable(instance, Barrier)
  
  return instance
end

function Barrier:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

function Barrier:render()
  self:renderComponents(self)
end

function Barrier:update() end
function Barrier:reset() end

return Barrier