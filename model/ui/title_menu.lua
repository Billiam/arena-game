local Menu = require('vendor.menu')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  'Start',
  function()
    Gamestate.push(Resource.state.game)
  end
)

menu:addItem(
  'Quit',
  function()
    love.event.quit()
  end
)

return menu