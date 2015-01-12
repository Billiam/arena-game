local beholder = require('vendor.beholder')
local Mixin = require('lib.mixin')

local Collidable = {}
setmetatable(Collidable, {__index = Mixin})

function Collidable:move(position)
  self.position = position
  beholder.trigger('COLLIDEMOVE', self)
end

function Collidable:place(position)
  self.position = position
  beholder.trigger('COLLIDEUPDATE', self)
end

return Collidable