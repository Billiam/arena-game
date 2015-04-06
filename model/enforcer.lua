local beholder = require('vendor.beholder')

local Collidable = require('model.mixin.collidable')
local Composable = require('model.mixin.composable')


local Enforcer = {
  isEnforcer = true,
  type = 'enforcer',
  colliderType = 'enforcer',
  height = 20,
  width = 20,
  speed = 20,
  isAlive = true
}

Enforcer.mt = { __index = Enforcer }

Composable:mixInto(Enforcer)
Collidable:mixInto(Enforcer)

function Enforcer.create(position)
  local instance = {
    position = position,
  }

  setmetatable(instance, Enforcer.mt)

  return instance
end

function Enforcer:update(dt, player)
  self:updateComponents(self, dt, player)
  if not player.isAlive then
    return
  end

  self:updatePosition(dt, player)
end

function Enforcer:updatePosition(dt, player)
end

function Enforcer:render()
  self:renderComponents(self)
end

function Enforcer.collide(enforcer, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive then
    if other.isPlayer or other.isBullet then
      return 'touch'
    end
  end
end

function Enforcer:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

return Enforcer