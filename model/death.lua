local Composable = require('model.mixin.composable')
local ZIndex = require('lib.zindex')
local Death = {
  type = 'death',
}

Death.mt = { __index = Death }

Composable:mixInto(Death)

function Death.create(entity)

  local instance = {
    width = entity.width,
    height = entity.height,
    position = entity.position:clone(),
    angle = entity.angle,
    velocity = entity.velocity,
    entity = entity,
    components = {},

    z = ZIndex.FLOOR
  }


  setmetatable(instance, Death.mt)

  return instance
end

function Death:update(dt)
  self:updateComponents(self, dt)
end

function Death:render()
  self:renderComponents(self)
end

return Death