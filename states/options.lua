local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local menu = require('model.ui.option_menu')

local Controller = require('lib.controller')

Options = {
  name = 'options'
}
setmetatable(Options, {__index = State})

function Options.enter(current, previous)
  State.enter()
  menu:reset()
end

function Options.update(dt)
  menu:update(dt)

  if Controller.menuUp(1) then
    menu:keypressed('up')
  end

  if Controller.menuDown(1)then
    menu:keypressed('down')
  end

  if Controller.menuSelect(1) then
    menu:keypressed('return')
  end
end

function Options.draw()
  Resource.view.options.render(menu)
end

return Options