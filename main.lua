local Gamepad = require('lib.joystick')
local Keyboard = require('lib.keyboard')

local Vector = require('vendor.h.vector')

local player = nil
local joystick = nil
local bullets = {}
local bulletSpeed = 500
local bulletTimer = 0
local gunDistance = 10
local jitter = 5

function love.load(arg)
  player = {
    position = Vector(256, 256),
    gunPosition = Vector(256, 256),
    speed = 250,
    angle = 0,
    fireSpeed = 0.01,
    width = 10,
    height = 20
  }
end

function love.joystickadded(new_joystick)
  if joystick == nil and new_joystick:isGamepad() then
    joystick = new_joystick
  end
end

function love.draw()
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle("fill", player.position.x, player.position.y, player.width, player.height)
  
  love.graphics.setColor(255, 0, 255)
  love.graphics.circle("fill", player.gunPosition.x, player.gunPosition.y, 4, 8)
  
  love.graphics.setColor(255, 0, 0)
  for i,v in ipairs(bullets) do
    love.graphics.circle("fill", v.position.x, v.position.y, 5)
  end
      
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Current fps: "..tostring(love.timer.getFPS( )), 6, 6)
end


function love.update(dt)
  local move = Vector(0,0)
  local aim = Vector(0,0)
  local gamepad = false
  
  if joystick then
    local deadzone = 0.105
    local left = Gamepad.parseLeft(joystick, deadzone)
    local right = Gamepad.parseRight(joystick, deadzone)
    
    if left:len2() > 0 or right:len2() > 0 then
      gamepad = true

      aim = right
      move = left
    end
  end
  
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  
  if gamepad == false then
    move = Keyboard.move()
    aim = Keyboard.aim()
  end
  
  player.position = player.position + move * player.speed * dt
  
  if aim:len2() > 0 then
    player.angle = aim:angleTo()
  end
  
  player.gunPosition = Vector(player.position.x + player.width/2 + gunDistance * math.cos(player.angle) , player.position.y + player.height/2 + gunDistance * math.sin(player.angle))
  
  local count = 0
  for i,v in ipairs(bullets) do
    v.position = v.position + v.velocity * dt
  
    if (v.position.x < -10) or (v.position.x > love.graphics.getWidth() + 10)
    or (v.position.y < -10) or (v.position.y > love.graphics.getHeight() + 10) then
      table.remove(bullets, i)
    end

    count = count + 1
  end
  
  local time = love.timer.getTime()
  if aim:len2() > 0 then
    if love.timer.getTime() > bulletTimer + player.fireSpeed then
      local angle = player.angle + math.pi * 0.5 * (love.math.random() - 0.5) * 0.1
      table.insert(bullets, {position = player.gunPosition:clone(), velocity = Vector(bulletSpeed * math.cos(angle), bulletSpeed * math.sin(angle))})
      bulletTimer = time
    end
  end
end
