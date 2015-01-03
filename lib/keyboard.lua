local Vector = require('vendor.h.vector')

local function move()
  local moveV = Vector(0,0)
  
  if love.keyboard.isDown('a') then
    moveV.x = moveV.x - 1
  end
  
  if love.keyboard.isDown('e') then
    moveV.x = moveV.x + 1
  end
  
  if love.keyboard.isDown(',') then
    moveV.y = moveV.y - 1
  end
  
  if love.keyboard.isDown('o') then
    moveV.y = moveV.y + 1
  end
  
  return moveV
end

local function aim()
  local aimV = Vector(0,0)
  
  if love.keyboard.isDown('left') then
    aimV.x = aimV.x - 1
  end
  
  if love.keyboard.isDown('right') then
    aimV.x = aimV.x + 1
  end
  
  if love.keyboard.isDown('up') then
    aimV.y = aimV.y - 1
  end
  
  if love.keyboard.isDown('down') then
    aimV.y = aimV.y + 1
  end
  
  return aimV
end

return {
  aim = aim,
  move = move
}