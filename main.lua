local Gamepad = require('lib.joystick')
local Keyboard = require('lib.keyboard')


local Player = require('model.player')

local BulletView = require('view.bullet')
local PlayerView = require('view.player')
local OSDView = require('view.osd')

local Vector = require('vendor.h.vector')

local player = nil
local joystick = nil
local bullets = {}
local bulletSpeed = 1200
local bulletTimer = 0
local gunDistance = 10

function love.load()
  player = Player.create(Vector(256,256))
end

function love.joystickadded(new_joystick)
  if joystick == nil and new_joystick:isGamepad() then
    joystick = new_joystick
  end
end

function love.draw()
  PlayerView.render(player)
  BulletView.render(bullets)
  OSDView.render()
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
      local bulletVelocity = Vector(bulletSpeed * math.cos(angle), bulletSpeed * math.sin(angle))
      table.insert(bullets, {position = player.gunPosition:clone(), velocity = bulletVelocity})
      player.position = player.position + bulletVelocity:rotated(math.pi) *.001
      bulletTimer = time
    end
  end
end
