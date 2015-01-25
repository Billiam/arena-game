local Menu = require('vendor.menu')

local Translator = require('lib.translate')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  Translator.NEW_GAME,
  function()
    Gamestate.push(Resource.state.game)
  end
)

menu:addItem(
  Translator.QUIT,
  function()
    love.event.quit()
  end
)

return menu