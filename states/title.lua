Gamestate = require('vendor.h.gamestate')
State = require('lib.state')
Resource = require('resource')

Controller = require('lib.controller')
Input = require('lib.input')

Title = {
  name = 'title'
}
setmetatable(Title, {__index = State})

function Title.update()
  if Controller.quit() then
    love.event.push('quit')
    return
  end
  
  if Controller.start() then
    Gamestate.push(Resource.state.game)
  end
end

function Title.draw()
  Resource.view.title.render()
end

return Title