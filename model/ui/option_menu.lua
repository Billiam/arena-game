local Translate = require('lib.translate')
local beholder = require('vendor.beholder')
local Menu = require('lib.dynamic_menu')
local Gamestate = require('vendor.h.gamestate')

local menu = Menu.create()

local listener = beholder.observe('LANGUAGE_UPDATE', function()
  menu:setup()
end)

menu:addItem(
  function(item)
    item.name = Translate.LANGUAGE
    item.value = Translate:currentLanguage()
    item.action = function(self)
      Translate:nextLanguage()
    end
  end
)

menu:addItem(
  function(item)
    item.name = Translate.VOLUME
    item.value = '100%'
    item.action = function()end
  end
)

menu:addItem(
  function(item)
    item.name = Translate.MUSIC
    item.value = '100%'
    item.action = function() end
  end
)

menu:addItem(
  function(item)
    item.name = Translate.FULLSCREEN
    item.value = 'on'
    item.action = function() end
  end
)

menu:addItem(
  function(item)
    item.name = Translate.BACK
    item.action = function()
      Gamestate.pop()
    end
  end
)

return menu