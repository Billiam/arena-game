local Resource = require('resource')
local Geometry = require('lib.geometry')

local Grunt = {
  type = 'grunt_view'
}
Grunt.mt = {__index = Grunt }

function Grunt.create()
  local instance = {}
  setmetatable(instance, Grunt.mt)
  return instance
end

function Grunt:render(grunt)
  local img = Resource.image['grunt/stand']

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
end

return Grunt