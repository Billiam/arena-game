local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
--local menu = require('model.ui.option_menu')
local OptionMenu = require('model.ui.option_menu')
local Input = require('lib.input')
local Controller = require('lib.controller')

local scene

Options = {
  name = 'options'
}
setmetatable(Options, {__index = State})

function Options.initGui()
  scene = OptionMenu.init(love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 100, 200)
end

function Options.enter(current, previous)
  State.enter()
  Options.initGui()
--  menu:reset()
end

function Options.update(dt)
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

function Options.draw()
  Resource.view.options.render(scene)
end

return Options