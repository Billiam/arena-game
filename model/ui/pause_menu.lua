local Translate = require('lib.translate')
local Gamestate = require('vendor.h.gamestate')
local Resource = require('resource')

local gui = require('lib.gui.init')

local PauseMenu = {}

function PauseMenu.init(x, y, width, scene)
  scene = scene or gui:scene()

  scene:add(
    gui:button({
      x = x,
      y = y,
      style = "overlay",
      width = width,
      text = Translate.RESUME,
    }):on('focus', function()
      Gamestate.pop()
    end)
  )

  scene:down(
    gui:button({
      style = "overlay",
      width = width,
      text = Translate.MAIN_MENU,
    }):on('focus', function()
      Gamestate.reset(Resource.state.title)
    end)
  )

  scene:down(
    gui:button({
      style = "overlay",
      width = width,
      text = Translate.QUIT,
    }):on('focus', function()
      love.event.quit()
    end)
  )

  scene:setHoverIndex(1)

  return scene
end

return PauseMenu