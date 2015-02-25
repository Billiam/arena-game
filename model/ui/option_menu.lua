local Translate = require('lib.translate')
local Gamestate = require('vendor.h.gamestate')
local Display = require('model.display')
local gui = require('lib.gui.init')
--local menu = Menu.create()

local OptionMenu = {}

function OptionMenu.init(x, y, width, scene)
  scene = scene or gui:scene()

  local labelWidth = 240
  local inputWidth = 220

  -- Language selection
  scene:add(
    gui:label({
      width = labelWidth,
      x = x,
      y = y,
      text = function() return Translate.LANGUAGE end
    })
  )

  scene:right(
    gui:button({
      index = false,
      width = 30,
      style = 'previous',
    }):on('focus', function()
      Translate:previousLanguage()
    end)
  )

  scene:right(
    gui:button({
      width = 100,
      width = inputWidth - 30 * 2,
      text = function() return Translate:currentLanguage() end
    }):on('focus', function()
      Translate:nextLanguage()
    end)
  )

  scene:right(
    gui:button({
      index = false,
      width = 30,
      style = 'next',
    }):on('focus', function()
      Translate:nextLanguage()
    end)
  )

  -- Sound volume
  scene:row(
    gui:label({
      index = false,
      width = labelWidth,
      text = function() return Translate.VOLUME end
    })
  )

  scene:right(
    gui:button({
      width = inputWidth,
      text = '100% (not working)'
    })
  )

  -- Music
  scene:row(
    gui:label({
      index = false,
      width = labelWidth,
      text = function() return Translate.MUSIC end
    })
  )

  scene:right(
    gui:button({
      width = inputWidth,
      text = '100% (not working)'
    })
  )


  -- Fullscreen selection
  scene:row(
    gui:label({
      width = labelWidth,
      text = function() return Translate.FULLSCREEN end
    })
  )

  scene:right(
    gui:button({
      index = false,
      width = 30,
      style = 'previous',
    }):on('focus', function()
      Display.previousMode()
    end)
  )

  scene:right(
    gui:button({
      width = 100,
      width = inputWidth - 30 * 2,
      text = function() return Translate[Display.currentMode()] end
    }):on('focus', function()
      Display:nextMode()
    end)
  )

  scene:right(
    gui:button({
      index = false,
      width = 30,
      style = 'next',
    }):on('focus', function()
      Display.nextMode()
    end)
  )

  -- Back
  scene:row(
    gui:button({
      y = 30,
      width = inputWidth + labelWidth,
      text = function() return Translate.BACK end
    }):on('focus', function()
      Gamestate.pop()
    end)
  )

  scene:setHoverIndex(1)

  return scene
end

return OptionMenu