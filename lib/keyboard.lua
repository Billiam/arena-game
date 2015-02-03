local Vector = require('vendor.h.vector')
local Input = require('lib.input')

local function move()
  local moveV = Vector(0,0)
  
  if Input.key.isDown('a') then
    moveV.x = moveV.x - 1
  end
  
  if Input.key.isDown('d') then
    moveV.x = moveV.x + 1
  end
  
  if Input.key.isDown('w') then
    moveV.y = moveV.y - 1
  end
  
  if Input.key.isDown('s') then
    moveV.y = moveV.y + 1
  end
  
  return moveV
end

local function aim()
  local aimV = Vector(0,0)
  
  if Input.key.isDown('j') then
    aimV.x = aimV.x - 1
  end
  
  if Input.key.isDown('l') then
    aimV.x = aimV.x + 1
  end
  
  if Input.key.isDown('i') then
    aimV.y = aimV.y - 1
  end
  
  if Input.key.isDown('k') then
    aimV.y = aimV.y + 1
  end
  
  return aimV
end

return {
  aim = aim,
  move = move
}