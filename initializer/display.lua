local Display = require('model.display')

local width, height, options = love.window.getMode()
local modes = love.window.getFullscreenModes()

table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)
local maxMode = modes[#modes]
love.graphics.setDefaultFilter('linear', 'nearest', 4)
options.x, options.y = 0, 0
love.window.setMode(maxMode.width, maxMode.height, options)

Display.init()