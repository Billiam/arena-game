local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Input = require('lib.input')
local Controller = require('lib.controller')
local menu = require('model.ui.pause_menu')

Pause = {
  name = 'pause'
}
setmetatable(Pause, {__index = State})

local canvas = nil
local previousState = nil

local blurh = love.graphics.newShader('lib/shader/blurh.glsl')
local blurv = love.graphics.newShader('lib/shader/blurv.glsl')

local temp1 = nil
local temp2 = nil

function Pause.init()
  temp1 = love.graphics.newCanvas()
  temp2 = love.graphics.newCanvas()
  
  blurh:send('screen', {love.graphics.getWidth(), love.graphics.getHeight()})
  blurv:send('screen', {love.graphics.getWidth(), love.graphics.getHeight()})
  blurh:send('steps', 12)
  blurv:send('steps', 12)
end

function Pause.enter(current, previous)
  State.enter()
  menu:reset()
  canvas = nil
  
  previousState = previous
end

function Pause.update(dt)
  menu:update(dt)

  if Controller.menuUp(1) then
    menu:keypressed('up')
  end

  if Controller.menuDown(1)then
    menu:keypressed('down')
  end

  if Controller.menuSelect(1) then
    menu:keypressed('return')
  end

  if Controller.unpause() then
    Gamestate.pop()
  end
end

function Pause.resize(...)
  if previousState then
    previousState.resize(...)
  end
end

function Pause.drawBelow()
  if not canvas then
    temp1:clear()
    temp2:clear()
    
    local previousCanvas = love.graphics.getCanvas()
    local previousShader = love.graphics.getShader()
    
    love.graphics.setCanvas(temp1)
    previousState.draw()
    
    Pause.blur(temp1, temp2)
    Pause.blur(temp1, temp2)
    
    canvas = temp1
    love.graphics.setShader(previousShader)
    love.graphics.setCanvas(previousCanvas)
  end
  
  love.graphics.draw(canvas)
end

function Pause.blur(input, cache)
  love.graphics.setShader(blurh)
  love.graphics.setCanvas(cache)
  love.graphics.draw(input)
  
  love.graphics.setShader(blurv)
  love.graphics.setCanvas(input)
  love.graphics.draw(cache)
end

function Pause.resize(...)
  if previousState then
    previousState.resize(...)
    canvas = nil
  end
end

function Pause.draw()
  if previousState then
    Pause.drawBelow()
  end
  
  Resource.view.pause.render(menu)
end

return Pause