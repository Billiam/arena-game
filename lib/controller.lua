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
  
  local joystick = Input.gamepads()[index]

  if joystick then
    local left = Gamepad.parseLeft(joystick)
    local right = Gamepad.parseRight(joystick)
    
    if left:len2() > 0 or right:len2() > 0 then
      gamepad = true

      aim = right
      move = left
    end
  end
  
  if gamepad == false then
    move = Keyboard.move()
    aim = Keyboard.aim()
  end
  
  return move, aim
end

-- todo: map actions to keys and gamepad actions
function Controller.unpause(index)
  index = index or 1
  return Input.gamepad.wasClicked(index, 'start') 
      or Input.key.wasClicked('p', 'escape')
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

function Controller.start(index)
  index = index or 1
  return Input.gamepad.wasClicked(index, 'start') or 
      Input.key.wasClicked('return')
end

return Controller