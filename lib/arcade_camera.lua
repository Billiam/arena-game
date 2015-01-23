local Camera = require('vendor.h.camera')
local ArcadeCamera = {}
ArcadeCamera.__index = ArcadeCamera

function ArcadeCamera.create(width, height)
  local instance = {
    w = width,
    h = height,
    camera = Camera.new()
  }

  setmetatable(instance, ArcadeCamera)
  return instance
end

function ArcadeCamera:init()
  self.camera:lookAt(self.w/2, self.h/2)
  self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function ArcadeCamera:resize(w, h)
  local scale = math.min(
    w / self.w,
    h / self.h
  )

  self.camera:zoomTo(scale)
end

function ArcadeCamera:attach()
  return self.camera:attach()
end

function ArcadeCamera:detach()
  return self.camera:detach()
end

return ArcadeCamera