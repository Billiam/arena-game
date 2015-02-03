local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Scores = require('model.scorekeeper')
local Highscores = require('model.highscores')
local Entry = require('model.name_entry')
local Controller = require('lib.controller')
local ScoreInput = require('component.score_input')

local Death = {
  name = 'death'
}
setmetatable(Death, {__index = State})

local previousState, entry


function Death.leave()
  entry = nil
end

function Death.enter(current, previous)
  State.enter()

  local lastScore = Scores.get()
  if Highscores:isHighscore(lastScore) then
    entry = Entry.create(ScoreInput.create(), { '', lastScore, os.time() })
  end
  
  previousState = previous
end

function Death.update()
  if entry then
    local score = entry:update()
    if score then
      Highscores:add(score)
      Gamestate.reset(Resource.state.title)
    end
  else
    if Controller.back() or Controller.start() then
      Gamestate.reset(Resource.state.title)
    end
  end
end

function Death.resize(...)
  if previousState then
    previousState.resize(...)
  end
end

function Death.draw()
  if previousState then
    previousState.draw()
  end
  
  Resource.view.death.render()
  
  if entry then
    Resource.view.name_entry.render(entry)
  end
end

return Death