local Geometry = require('lib.geometry')

local Spark = {
  type = 'spark_view'
}
Spark.mt = {__index = Spark }

function Spark.create()
  local instance = {
    angle = love.math.random() * Geometry.CIRCLE
  }

  setmetatable(instance, Spark.mt)

  return instance
end

function Spark:update(spark, dt)
  self.angle = self.angle + dt * Geometry.CIRCLE
end

function Spark:render(spark)
  love.graphics.push()
    love.graphics.translate(spark.position.x + spark.width/2, spark.position.y + spark.height/2)
    love.graphics.rotate(self.angle)
    love.graphics.setColor(255, 0, 255)
    love.graphics.rectangle('fill', -spark.width/2, -spark.height/2, spark.width, spark.height)
  love.graphics.pop()

  love.graphics.setColor(255, 255, 255, 255)
end

return Spark