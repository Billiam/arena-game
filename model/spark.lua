local Geometry = require('lib.geometry')
local Vector = require('vendor.h.vector')
local Composable = require('model.mixin.composable')
local Collidable = require('model.mixin.collidable')

local beholder = require('vendor.beholder')
local cron = require('vendor.cron')

local Spark = {
  isSpark = true,
  colliderType = 'spark',
  type = 'spark',
  isAlive = true,
  width = 10,
  height = 10,
}
Spark.mt = { __index = Spark }

Composable:mixInto(Spark)
Collidable:mixInto(Spark)

function Spark.create(position, velocity)
  local instance = {
    position = position - Vector.new(Spark.width/2, Spark.height/2),
    velocity = velocity,
    acceleration = Vector.fromAngle(Geometry.randomAngle(), 150 * love.math.random()),
  }

  setmetatable(instance, Spark.mt)

  instance.timer = cron.after(3, instance.timeout, instance)

  return instance
end

function Spark:render()
  self:renderComponents(self)
end

function Spark:update(dt)
  self:updateComponents(self, dt)

  self.timer:update(dt)
  self.velocity = self.velocity + self.acceleration * dt

  self:move(self.position + self.velocity * dt)
end

function Spark:timeout()
  self.isAlive = false
end

function Spark:kill()
  self.isAlive = false
  beholder.trigger('KILL', self)
end

function Spark.collide(spark, other)
  if other.isWall then
    return 'slide'
  elseif other.isAlive and (other.isBullet or other.isPlayer) then
    return 'touch'
  end
end

return Spark