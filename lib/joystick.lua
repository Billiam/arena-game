local Vector = require('vendor.h.vector')
local Input = require('lib.input')

local defaultDeadzone = 0.105

local function parseJoy(stick, joystick, deadzone)
  deadzone = deadzone or defaultDeadzone
  
  local joystickVector = Vector(
    joystick:getGamepadAxis(stick .. 'x'), 
    joystick:getGamepadAxis(stick .. 'y')
  )
  
  local magnitude = joystickVector:len()
  
  if (magnitude > deadzone) then
    return joystickVector:normalized() * ((magnitude - deadzone) / (1 - deadzone))
  end
end

local function parseDpad(joystick)
  local outputVector = Vector(0,0)
  
  if joystick:isGamepadDown('dpup') then
    outputVector.y = -1
  elseif joystick:isGamepadDown('dpdown') then
    outputVector.y = 1
  end
  
  if joystick:isGamepadDown('dpleft') then
    outputVector.x = -1
  elseif joystick:isGamepadDown('dpright') then
    outputVector.x = 1
  end
  
  return outputVector
end

local function parseLeft(joystick, deadzone)
  local outputVector = parseDpad(joystick)
  
  if outputVector:len2() == 0 then
    outputVector = parseJoy('left', joystick, deadzone) or outputVector
  end
  
  return outputVector
end

local function parseRight(joystick, deadzone)
  return parseJoy('right', joystick, deadzone) or Vector(0,0)
end

return {
  parseLeft = parseLeft,
  parseRight = parseRight
}