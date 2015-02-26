local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')

local Input = require('lib.input')
local Controller = require('lib.controller')

local PauseMenu = require('model.ui.pause_menu')

Pause = {
  name = 'pause'
}
setmetatable(Pause, {__index = State})

local scene
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

function Pause.initGui()
  scene = PauseMenu.init(love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 100, 200)
end

function Pause.enter(current, previous)
  State.enter()
  canvas = nil

  Pause.initGui()
  previousState = previous
end

function Pause.update(dt)
  local movePos = Input.mouse.moved()
  if movePos.x or movePos.y then
    scene:mouseMove(movePos.x, movePos.y)
  end

  if Input.mouse.wasPressed() then
    local pos = Input.mouse.position()
    scene:mouseDown(pos.x, pos.y)
  end

  if Controller.menuUp(1) then
    scene:previous()
  end

  if Controller.menuDown(1)then
    scene:next()
  end

  if Controller.menuSelect() then
    scene:activate()
  end

  if Controller.unpause() then
    Gamestate.pop()
  end
end

function Pause.resize(...)
  if previousState then
    previousState.resize(...)
    canvas = nil
  end

  --retain current hover state during rebuild
  local oldState = scene

  Pause.initGui()

  -- set the hover element to the old hover element
  scene:setHoverIndex(oldState:hoverIndex())
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

function Pause.draw()
  if previousState then
    Pause.drawBelow()
  end
  
  Resource.view.pause.render(scene)
end

return Pause