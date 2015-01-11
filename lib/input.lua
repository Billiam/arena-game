local Input = {}

local store = {
  gamepads = { },
  buttonsCurrentlyPressed = { },
  buttonsPressed = { },
  buttonsReleased = { },
  buttonsClicked = { },

  keysCurrentlyPressed = { },
  keysPressed = { },
  keysReleased = { },
  keysClicked = { },
}

Input.key = {}
Input.gamepad = {}


-- love2d method callbacks
function love.gamepadpressed(gamepad, key)
  if not store.buttonsPressed[gamepad] then
    store.buttonsPressed[gamepad] = {}
  end
  if not store.buttonsCurrentlyPressed[gamepad] then
    store.buttonsCurrentlyPressed[gamepad] = {}
  end
  
  store.buttonsPressed[gamepad][key] = true
  store.buttonsCurrentlyPressed[gamepad][key] = true
end

function love.gamepadreleased(gamepad, key)
  if not store.buttonsReleased[gamepad] then
    store.buttonsReleased[gamepad] = {}
  end
    
  store.buttonsReleased[gamepad][key] = true
  
  if store.buttonsCurrentlyPressed[gamepad] and store.buttonsCurrentlyPressed[gamepad][key] then
    store.buttonsCurrentlyPressed[gamepad][key] = nil
    
    if not store.buttonsClicked[gamepad] then
      store.buttonsClicked[gamepad] = {}
    end
    store.buttonsClicked[gamepad][key] = true
  end
end

function love.keypressed(key)
  store.keysPressed[key] = true
  store.keysCurrentlyPressed[key] = true
end

function love.keyreleased(key)
  store.keysReleased[key] = true
  
  if store.keysCurrentlyPressed[key] then
    store.keysCurrentlyPressed[key] = nil
    store.keysClicked[key] = true
  end
end

function love.joystickadded(joystick)
  if joystick:isGamepad() then
    Input.gamepad.add(joystick)
  end
end

-- Input state clearing
local function clearTable(table)
  for k in pairs(table) do
    table[k] = nil
  end
end

function Input.forget()
  Input.clear()
  clearTable(store.buttonsCurrentlyPressed)
  clearTable(store.keysCurrentlyPressed)
end

function Input.clear()
  clearTable(store.keysPressed)
  clearTable(store.keysReleased)
  clearTable(store.keysClicked)

  clearTable(store.buttonsPressed)
  clearTable(store.buttonsReleased)
  clearTable(store.buttonsClicked)
end

function Input.gamepads()
  return store.gamepads
end

function Input.gamepad.add(gamepad)
  table.insert(store.gamepads, gamepad)
end

local function anyElement(field, ...)
  for i,v in ipairs({...}) do
    if store[field][v] then
      return true
    end
  end
end

-- API for checking individual buttons
function Input.key.wasPressed(...)
  return anyElement('keysPressed', ...)
end

function Input.key.wasReleased(...)
  return anyElement('keysReleased', ...)
end

function Input.key.wasClicked(...)
  return anyElement('keysClicked', ...)
end

function Input.key.isDown(...)
  return anyElement('keysCurrentlyPressed', ...)
end

function Input.gamepad.wasPressed(index, key)
  local gamepad = store.gamepads[index]
  return store.buttonsPressed[gamepad] and store.buttonsPressed[gamepad][key]
end

function Input.gamepad.wasReleased(index, key)
  local gamepad = store.gamepads[index]
  return store[gamepad] and store[gamepad][key]
end

function Input.gamepad.wasClicked(index, key)
  local gamepad = store.gamepads[index]
  return store.buttonsClicked[gamepad] and store.buttonsClicked[gamepad][key]
end

function Input.gamepad.isDown(index, key)
  local gamepad = store.gamepads[index]
  return store.buttonsCurrentlyPressed[gamepad] and store.buttonsCurrentlyPressed[gamepad][key]
end

return Input