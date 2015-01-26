local Translate = require('lib.translate')

local Menu = require('lib.dynamic_menu')
local Gamestate = require('vendor.h.gamestate')
local beholder = require('vendor.beholder')
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
      Gamestate.pop()
    end
  },
  function(item)
    item.name = Translate.RESUME
  end
)

menu:addItem(
  {
    action = function()
      Gamestate.reset(Resource.state.title)
    end
  },
  function(item)
    item.name = Translate.MAIN_MENU
  end
)

menu:addItem(
  {
    action =  function()
      love.event.quit()
    end
  },
  function(item)
    item.name = Translate.QUIT
  end
)

return menu