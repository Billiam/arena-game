local Config = require('model.config')
local Enumerable = require('vendor.enumerable')
local Display = {}

local screenModes = Enumerable.create({'ON', 'OFF', 'BORDERLESS'})

function Display.init()
  Display.setFullscreen(Config:get('fullscreen', true))
end

function Display.currentMode()
  local current
  local fullscreen, type = love.window.getFullscreen()

  if not fullscreen then
    return 'OFF'
  elseif type == 'desktop' then
    return 'BORDERLESS'
  else
    return 'ON'
  end
end

function Display.offsetMode(offset)
  offset = offset or 1

  local current = Display.currentMode()

  local currentPosition = screenModes:find_index(function(i) return i == current end)
  local offsetPosition = (currentPosition - 1 + offset) % screenModes:count() + 1
  return screenModes[offsetPosition]
end

function Display.previousMode()
  Display.setFullscreen(Display.offsetMode(-1))
end

function Display.nextMode()
  Display.setFullscreen(Display.offsetMode(1))
end

function Display.setFullscreen(status)
  local enabled = true
  local screenType = 'normal'
  
  if status == 'BORDERLESS' then
    screenType = 'desktop'
  elseif status == 'OFF' then
    enabled = false
  else
    status = 'ON'
  end
  
  Config:set('fullscreen', status)
  love.window.setFullscreen(enabled, screenType)
end

return Display