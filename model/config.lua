local defaults = {
  FILENAME = 'settings.conf'
}

local Serializer = require('vendor.smallfolk')

local Config = {}

local data

function Config:data()
  if not data then
    data = self:load()
  end

  return data
end

function Config:load()
  local content = love.filesystem.read(defaults.FILENAME)

  if not content then
    return {}
  end

  local success, parsed = pcall(function() return Serializer.loads(content) end)

  return success and parsed or {}
end

function Config:save()
  local serialized = Serializer.dumps(self:data())
  love.filesystem.write(defaults.FILENAME, serialized)
end

function Config:set(key, value)
  assert(key, 'Config key is required')

  self:data()[key] = value
  self:save()
end

function Config:get(key, default)
  local val = self:data()[key]
  return val ~= nil and val or default
end

return Config