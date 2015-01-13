local Score = {}
Score.__index = Score

function Score.render(score)
  love.graphics.print(score, 500, 6)
end

return Score