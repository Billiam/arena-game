local Collection = require('model.collection')
local Wall = require('model.wall')
local Vector = require('vendor.h.vector')

local Arena = {
  isArena = true,
  width = 0,
  height = 0,
  position = Vector(0,0)
}

Arena.mt = { __index = Arena }
Arena.__index = Arena

function Arena.create(inset, collider)
  local instance = {
    walls = Collection.create(collider),
    visible = true
  }
  
  local self = setmetatable(instance, Arena.mt)
  
  self:generateWalls(inset, collider)
  
  return self
end

function Arena:generateWalls(inset, collider)
  local thickness = 30

  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  
  local horizontalWidth = screenWidth - 2 * inset + 2 * thickness
  local verticalHeight = screenHeight - 2 * inset + 2 * thickness
  
  local topLeft = Vector(inset - thickness, inset - thickness)
  local bottomLeft = Vector(inset - thickness, screenHeight - inset)
  local topRight = Vector(screenWidth - inset, inset - thickness)
  
  local wall1 = Wall.create(topLeft, horizontalWidth, thickness)
  local wall2 = Wall.create(bottomLeft, horizontalWidth, thickness)
  
  local wall3 = Wall.create(topLeft, thickness, verticalHeight)
  local wall4 = Wall.create(topRight, thickness, verticalHeight)

  self.walls:add(wall1)
  self.walls:add(wall2)
  self.walls:add(wall3)
  self.walls:add(wall4)
  
  self.width = horizontalWidth - 2 * thickness
  self.height = verticalHeight - 2 * thickness
  self.position = Vector(topLeft.x + thickness, topLeft.y + thickness)
end

return Arena