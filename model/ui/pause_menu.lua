local Menu = require('vendor.menu')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  'Continue',
  function()
    Gamestate.pop()
  end
)

menu:addItem(
  'End Game',
  function()
    Gamestate.reset(Resource.state.title)
  end
)

menu:addItem(
  'Quit',
  function()
    love.event.quit()
  end
)

return menu