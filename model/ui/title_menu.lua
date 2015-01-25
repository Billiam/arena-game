local Menu = require('vendor.menu')

local Translator = require('lib.translate')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  Translator:get('menu', 'new'),
  function()
    Gamestate.push(Resource.state.game)
  end
)

menu:addItem(
  Translator:get('menu', 'quit'),
  function()
    love.event.quit()
  end
)

return menu