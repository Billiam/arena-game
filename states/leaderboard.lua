local Gamestate = require('vendor.h.gamestate')
local State = require('lib.state')
local Resource = require('resource')
local Highscores = require('model.highscores')

local Controller = require('lib.controller')

local Leaderboard = {
  name = 'Leaderboard'
}
setmetatable(Leaderboard, {__index = State})

local scores

function Leaderboard.enter(current)
  State.enter()
  scores = Highscores:data()
end

function Leaderboard.update()
  if Controller.menuSelect() then
    Gamestate.pop()
  end
end

function Leaderboard.draw()
  Resource.view.leaderboard.render(scores)
end

return Leaderboard