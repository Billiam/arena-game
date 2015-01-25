local Translator = require('lib.translate')

local Menu = require('vendor.menu')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.new()

menu:addItem(
  Translator:get('menu','resume'),
  function()
    Gamestate.pop()
  end
)

menu:addItem(
  Translator:get('dialog','button.abort'),
  function()
    Gamestate.reset(Resource.state.title)
  end
)

menu:addItem(
  Translator:get('menu', 'quit'),
  function()
    love.event.quit()
  end
)

return menu