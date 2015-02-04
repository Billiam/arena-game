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

function Display.nextMode()
  local current = Display.currentMode()

  local currentPosition = screenModes:find_index(function(i) return i == current end)
  local nextPosition = currentPosition % screenModes:count() + 1
  local newMode = screenModes[nextPosition]
  
  Display.setFullscreen(newMode)
  
  return newMode
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