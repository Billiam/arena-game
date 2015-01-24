local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')

local Controller = require('lib.controller')
local Input = require('lib.input')

local menu = require('model.ui.title_menu')

local Title = {
  name = 'title'
}
setmetatable(Title, {__index = State})

local timer = 0

function Title.enter()
  timer = 0
  menu:reset()
end

function Title.update(dt)
  menu:update(dt)

  if Controller.menuUp(1) then
    menu:keypressed('up')
  end

  if Controller.menuDown(1)then
    menu:keypressed('down')
  end

  if Controller.menuSelect() then
    menu:keypressed('return')
  end

  timer = timer + dt
end

function Title.draw()
  Resource.view.title.render(timer, menu)
end

return Title