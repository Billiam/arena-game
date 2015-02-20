local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Highscores = require('model.highscores')
local gui = require('lib.gui.init')
local Translate = require('lib.translate')
local Controller = require('lib.controller')
local Input = require('lib.input')

local Leaderboard = {
  name = 'Leaderboard'
}
setmetatable(Leaderboard, {__index = State})

local scores
local scene

local function initMenu()
  local width = 150

  scene = gui:scene()

  scene:add(
    gui:button({
      x = (love.graphics.getWidth() - width) / 2,
      y = love.graphics.getHeight() - 100,
      style = "menu",
      width = width,
      text = Translate.BACK,
    }):on('focus', function()
      Gamestate.pop()
    end)
  )
  scene:setHoverIndex(1)
end

function Leaderboard.resize()
  initMenu()
end

function Leaderboard.enter(current)
  State.enter()
  scores = Highscores:data()
  initMenu()
end

function Leaderboard.update()
  local movePos = Input.mouse.moved()
  if movePos.x or movePos.y then
    scene:mouseMove(movePos.x, movePos.y)
  end

  if Input.mouse.wasPressed() then
    local pos = Input.mouse.position()
    scene:mouseDown(pos.x, pos.y)
  end

  if Controller.menuUp(1) then
    scene:previous()
  end

  if Controller.menuDown(1)then
    scene:next()
  end

  if Controller.menuSelect() then
    scene:activate()
  end

end

function Leaderboard.draw()
  Resource.view.leaderboard.render(scores, scene)
end

return Leaderboard