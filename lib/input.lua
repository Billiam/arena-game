local Gamepad = require('lib.joystick')

local Input = {
  mouse = {},
  gamepad = {},
  key = {},
}

local mouse = {
  position = {},
  newPosition = {},
  held = {},
  pressed = {},
  released = {},
}

local pad = {
  list = {},
  axes = {},

  held = {},
  pressed = {},
  released = {},
}

local keys = {
  held = {},
  pressed = {},
  released = {},
}

local text = {}

local function scancode(key)
  return love.keyboard.getScancodeFromKey(key)
end

-- love2d method callbacks
function love.mousemoved(x, y, distx, disty)
  if x ~= mouse.position.x or y ~= mouse.position.y then
    mouse.newPosition.x, mouse.newPosition.y = x, y
  end
  
  mouse.position.x, mouse.position.y = x, y
end

function love.mousepressed(x, y, button)
  local position = { x = x, y = y }
  mouse.pressed[button] = position
  mouse.held[button] = position
end

function love.mousereleased(x, y, button)
  if mouse.held[button] then
    mouse.held[button] = nil
    mouse.released[button] = { x = x, y = y }
  end
end

function love.gamepadpressed(gamepad, key)
  pad.pressed[gamepad] = pad.pressed[gamepad] or {}
  pad.held[gamepad] = pad.held[gamepad] or  {}

  pad.pressed[gamepad][key] = true
  pad.held[gamepad][key] = true
end

function love.gamepadreleased(gamepad, key)
  if pad.held[gamepad] and pad.held[gamepad][key] then
    pad.held[gamepad][key] = nil
    pad.released[gamepad] = pad.released[gamepad] or {}

    pad.released[gamepad][key] = true
  end
end

function love.textinput(char)
  table.insert(text, char)
end

function love.keypressed(key)
  key = scancode(key)

  keys.pressed[key] = true
  keys.held[key] = true
end

function love.keyreleased(key)
  key = scancode(key)

  if keys.held[key] then
    keys.held[key] = false
    keys.released[key] = true
  end
end

function love.joystickadded(joystick)
  if joystick:isGamepad() then
    Input.gamepad.add(joystick)
  end
end

-- Input state clearing
local function clearTable(table, value)
  for k in pairs(table) do
    table[k] = value
  end
end

function Input.forget()
  Input.clear()

  clearTable(pad.held, {})
  
  clearTable(keys.held)
  clearTable(mouse.held)
end

function Input.clear()
  clearTable(keys.pressed)
  clearTable(keys.released)

  clearTable(mouse.pressed)
  clearTable(mouse.released)
  clearTable(mouse.newPosition)
  
  clearTable(pad.pressed, {})
  clearTable(pad.released, {})
  clearTable(pad.axes, {})
  

  clearTable(text)
end

function Input.gamepads()
  return pad.list
end

function Input.gamepad.add(gamepad)
  table.insert(pad.list, gamepad)
end

local function anyKey(field, ...)
  for i,v in ipairs({...}) do
    if keys[field][v] then
      return true
    end
  end
end

-- API for checking individual buttons
function Input.key.wasPressed(...)
  return anyKey('pressed', ...)
end

function Input.key.wasClicked(...)
  return anyKey('released', ...)
end

function Input.key.isDown(...)
  return anyKey('held', ...)
end

function Input.gamepad.wasPressed(index, key)
  local gamepad = pad.list[index]
  return pad.pressed[gamepad] and pad.pressed[gamepad][key]
end

function Input.gamepad.wasClicked(index, key)
  local gamepad = pad.list[index]
  return pad.released[gamepad] and pad.released[gamepad][key]
end

function Input.mouse.position()
  return mouse.position
end

function Input.mouse.moved()
  return mouse.newPosition
end

function Input.mouse.wasPressed(button)
  button = button or "l"
  return mouse.pressed[button]
end

function Input.mouse.wasClicked(button)
  button = button or "l"
  return mouse.released[button]
end

function Input.mouse.isDown(button)
  button = button or "l"
  return mouse.held[button]
end

-- check poll-only events
function Input.update()
  for i,gamepad in ipairs(pad.list) do

    pad.axes[gamepad] = pad.axes[gamepad] or {}

    pad.held[gamepad] = pad.held[gamepad] or {}
    pad.pressed[gamepad] = pad.pressed[gamepad] or {}
    pad.released[gamepad] = pad.released[gamepad] or {}

    local axes = pad.axes[gamepad]

    local held = pad.held[gamepad]
    local pressed = pad.pressed[gamepad]
    local released = pad.released[gamepad]

    axes.left = Gamepad.parseLeft(gamepad)
    axes.right = Gamepad.parseRight(gamepad)

    -- differs from deadzone
    -- require at least this value in target direction (non circular deadzone)
    local minOffset = 0.5
    --convert analog input to digital
    if axes.left.x < -minOffset then
      if not held.left then
        pressed.left = true
      end

      held.left = true
    else
      if held.left then
        released.left = true
      end

      held.left = false
    end

    if axes.left.x > minOffset then
      if not held.right then
        pressed.right = true
      end

      held.right = true
    else
      if held.right then
        released.right = true
      end
      held.right = false
    end

    if axes.left.y < -minOffset then
      if not held.up then
        pressed.up = true
      end

      held.up = true
    else
      if held.up then
        released.up = true
      end

      held.up = false
    end

    if axes.left.y > minOffset then
      if not held.down then
        pressed.down = true
      end

      held.down = true
    else
      if held.down then
        released.down = true
      end

      held.down = false
    end
  end
end

function Input.gamepad.axes(index)
  local gamepad = pad.list[index]
  return pad.axes[gamepad]
end

function Input.gamepad.isDown(index, key)
  local gamepad = pad.list[index]
  return pad.held[gamepad] and pad.held[gamepad][key]
end

function Input.text()
  local i = 0
  local n = #text

  return function()
    i = i + 1
    if i <= n then return text[i] end
  end
end

return Input