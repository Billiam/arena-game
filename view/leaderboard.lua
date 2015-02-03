local Translate = require('lib.translate')
local Resource = require('resource')
local Leaderboard = {}

function Leaderboard.render(scores)
  Resource.view.background.render(love.graphics.getWidth(), love.graphics.getHeight())
  
  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth()/2 - 100, 100)
  love.graphics.setFont(Resource.font.noto_black[20])
  love.graphics.setColor(50, 50, 50, 255)
  
  for i,score in ipairs(scores) do
    love.graphics.print(score[1]:upper(), 0, 0)
    love.graphics.print(score[2], 100, 0)
    love.graphics.translate(0, 30)
  end

  love.graphics.pop()

  love.graphics.printf(Translate.BACK, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), 'center')
  love.graphics.setColor(255, 255, 255, 255)
end

return Leaderboard