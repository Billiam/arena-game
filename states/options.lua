local State = require('lib.state')
local Resource = require('resource')
local OptionMenu = require('model.ui.option_menu')
local Input = require('lib.input')
local Controller = require('lib.controller')

local scene

Options = {
  name = 'options'
}
setmetatable(Options, {__index = State})

function Options.initGui()
  scene = OptionMenu.init(love.graphics.getWidth()/2 - 230, love.graphics.getHeight()/3, 220, 240)
end

function Options.enter(current, previous)
  State.enter()
  Options.initGui()
end

function Options.resize(...)
  local oldState = scene

  Options.initGui()

  -- set the hover element to the old hover element
  scene:setHoverIndex(oldState:hoverIndex())
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

  if Controller.menuRight(1) then
    scene:selectionNext()
  end

  if Controller.menuLeft(1) then
    scene:selectionPrevious()
  end

  if Controller.menuSelect() then
    scene:activate()
  end
end

function Options.draw()
  Resource.view.options.render(scene)
end

return Options