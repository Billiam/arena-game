local Vector = require('vendor.h.vector')
local Input = require('lib.input')

local function move()
  local moveV = Vector(0,0)
  
  if Input.key.isDown('a') then
    moveV.x = moveV.x - 1
  end
  
  if Input.key.isDown('e') then
    moveV.x = moveV.x + 1
  end
  
  if Input.key.isDown(',') then
    moveV.y = moveV.y - 1
  end
  
  if Input.key.isDown('o') then
    moveV.y = moveV.y + 1
  end
  
  return moveV
end

local function aim()
  local aimV = Vector(0,0)
  
  if Input.key.isDown('h') then
    aimV.x = aimV.x - 1
  end
  
  if Input.key.isDown('n') then
    aimV.x = aimV.x + 1
  end
  
  if Input.key.isDown('c') then
    aimV.y = aimV.y - 1
  end
  
  if Input.key.isDown('t') then
    aimV.y = aimV.y + 1
  end
  
  return aimV
end

return {
  aim = aim,
  move = move
}