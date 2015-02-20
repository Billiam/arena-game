local gui = require('lib.gui.gui')
local Resource = require('resource')
local Gamestate = require('vendor.h.gamestate')
local Translate = require('lib.translate')

local TitleMenu = {}

function TitleMenu.init(scene, width, startX, startY)
  scene:add(
    gui:button({
      x = startX,
      y = startY,
      style = "menu",
      width = width,
      text = Translate.NEW_GAME,
    }):on('focus', function()
      Gamestate.push(Resource.state.game)
    end)
  )

  scene:down(
    gui:button({
      style = "menu",
      width = width,
      text = Translate.HIGHSCORES,
    }):on('focus', function()
      Gamestate.push(Resource.state.leaderboard)
    end)
  )

  scene:down(
    gui:button({
      style = "menu",
      width = width,
      text = Translate.OPTIONS,
    }):on('focus', function()
      Gamestate.push(Resource.state.options)
    end)
  )

  scene:down(
    gui:button({
      style = "menu",
      width = width,
      text = Translate.QUIT,
    }):on('focus', function()
      love.event.quit()
    end)
  )

  scene:setHoverIndex(1)
end

return TitleMenu