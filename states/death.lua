Gamestate = require('vendor.h.gamestate')
State = require('lib.state')
Resource = require('resource')

Controller = require('lib.controller')
Input = require('lib.input')

Death = {
  name = 'death'
}
setmetatable(Death, {__index = State})

local previousState = nil

function Death.enter(current, previous)
  State.enter()
  
  previousState = previous
end

function Death.update()
  if Controller.back() or Controller.start() then
    Gamestate.reset(Resource.state.title)
  end
end

function Death.draw()
  if previousState then
    previousState.draw()
  end
  
  Resource.view.death.render()
end

return Death