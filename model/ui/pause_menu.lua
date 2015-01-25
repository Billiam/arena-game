local Translator = require('lib.translate')

local Menu = require('vendor.menu')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  Translator.RESUME,
  function()
    Gamestate.pop()
  end
)

menu:addItem(
  Translator.MAIN_MENU,
  function()
    Gamestate.reset(Resource.state.title)
  end
)

menu:addItem(
  Translator.QUIT,
  function()
    love.event.quit()
  end
)

return menu