local Input = require('lib.input')
local Keyboard = require('lib.keyboard')
local Gamepad = require('lib.joystick')
local Vector = require('vendor.h.vector')

local Controller = {}

function Controller.player(index)
  index = index or 1
  
  local move = Vector(0,0)
  local aim = Vector(0,0)
  local gamepad = false
  
  local axes = Input.gamepad.axes(index)
  if axes and axes.left and axes.right then
    if axes.left:len2() > 0 or axes.right:len2() > 0 then
      gamepad = true
      aim = axes.right
      move = axes.left
    end
  end
  
  if not gamepad then
    move = Keyboard.move()
    aim = Keyboard.aim()
  end
  
  return move, aim
end

function Controller.menuBack(index)
  index = index or 1
  
  return Input.gamepad.wasPressed(index, 'b')
end

function Controller.menuUp(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'up')
    or Input.key.wasPressed(',', 'up')
end

function Controller.menuDown(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'down')
    or Input.key.wasPressed('o', 'down')
end

function Controller.menuLeft(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'left')
    or Input.key.wasPressed('a', 'left')
end

function Controller.menuRight(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'right')
    or Input.key.wasPressed('e', 'right')
end

function Controller.menuSelect(index)
  index = index or 1

  return Input.gamepad.wasPressed(index, 'start')
    or Input.gamepad.wasPressed(index, 'a')
    or Input.key.wasPressed('return')
end

function Controller.unpause(index)
  return Input.key.wasClicked('p', 'escape')
end

function Controller.back(index)
  index = index or 1
  
  return Input.gamepad.wasClicked(index, 'start')
    or Input.gamepad.wasClicked(index, 'a')
    or Input.key.wasClicked('escape', 'enter')
end

function Controller.pause(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'start') 
      or Input.key.wasPressed('p', 'escape')
end

function Controller.quit(index)
  index = index or 1
  return Input.gamepad.wasClicked(index, 'b') or
      Input.key.wasClicked('escape', 'q')
end

function Controller.nextLetter(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'up')
    or Input.key.wasPressed('up')
end

function Controller.previousLetter(index)
  index = index or 1
  return Input.gamepad.wasPressed(index, 'down')
    or Input.key.wasPressed('down')
end

function Controller.start(index)
  index = index or 1
  return Input.gamepad.wasClicked(index, 'start') or 
      Input.key.wasClicked('return')
end

return Controller