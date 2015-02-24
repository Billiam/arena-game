local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')

local Controller = require('lib.controller')
local Input = require('lib.input')

local TitleMenu = require('model.ui.title_menu')

local scene

local Title = {
  name = 'title'
}
setmetatable(Title, {__index = State})

local timer = 0

function Title.enter()
  timer = 0
  Title.initGui()
end

function Title.resume()
  Title.initGui()
end

function Title.initGui()
  scene = TitleMenu.init(300, love.graphics.getWidth() - 300, love.graphics.getHeight()/2 - 200)
end

function Title.resize()
  --retain current hover state during rebuild
  local oldState = scene

  TitleMenu.initGui()

  -- set the hover element to the old hover element
  scene:setHoverIndex(oldState:hoverIndex())
end

function Title.update(dt)
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

  timer = timer + dt
end

function Title.draw()
  Resource.view.title.render(timer, scene)
  love.graphics.setColor(255, 255, 255, 255)
end

return Title