Gamestate = require('vendor.h.gamestate')
State = require('lib.state')
Resource = require('resource')

Controller = require('lib.controller')
Input = require('lib.input')

Title = {
  name = 'title'
}
setmetatable(Title, {__index = State})

local timer = 0

function Title.enter()
  timer = 0
end

function Title.update(dt)
  if Controller.quit() then
    love.event.push('quit')
    return
  end
  
  if Controller.start() then
    Gamestate.push(Resource.state.game)
  end

  timer = timer + dt
end

function Title.draw()
  Resource.view.title.render(timer)
end

return Title