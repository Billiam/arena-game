local Resource = require('resource')
local Geometry = require('lib.geometry')

local stand = Resource.image['grunt/stand']

local Grunt = {
  type = 'grunt_view'
}
Grunt.mt = {__index = Grunt }

function Grunt.create()
  local instance = {
    accumulator = 0
  }
  setmetatable(instance, Grunt.mt)
  return instance
end

function Grunt:update(grunt, dt)
  self.accumulator = self.accumulator + dt
end

function Grunt:render(grunt)
  local img
  if grunt.isAlive then
    img = Resource.image['grunt/stand']
    love.graphics.setColor({255, 255, 255, 255})
  else
    img = Resource.image['grunt/hit']

    love.graphics.setColor({255, 255, 255, math.max(0, 1 - (self.accumulator)) * 255})
  end

  local offset = img:getWidth() - 3
  local width = -1

  if math.abs(Geometry.radianDiff(grunt.angle, math.pi)) >= Geometry.QUARTERCIRCLE then
    width = 1
    offset = 0
  end

  love.graphics.draw(
    img,
    grunt.position.x - 1,
    grunt.position.y - 4,
    0,
    width,
    1,
    offset
  )
  love.graphics.setColor({255, 255, 255, 255})
end

return Grunt