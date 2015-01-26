local Translate = require('lib.translate')
local beholder = require('vendor.beholder')
local Menu = require('lib.dynamic_menu')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local menu = Menu.create()

local listener = beholder.observe(
  'LANGUAGE_UPDATE',
  function()
    menu:setup()
  end
)

menu:addItem(
  {
    action = function()
      Gamestate.push(Resource.state.game)
    end
  },
  function(item)
    item.name = Translate.NEW_GAME
  end
)

menu:addItem(
  {
    action = function()
      Gamestate.push(Resource.state.options)
    end
  },
  function(item)
    item.name = Translate.OPTIONS
  end
)

menu:addItem(
  {
    action = function()
      love.event.quit()
    end
  },
  function(item)
    item.name = Translate.QUIT
  end
)

return menu