local Lives = {}
Lives.__index = Lives

function Lives.render(waves)
  love.graphics.print("Wave: " .. waves:waveNumber(), 300, love.graphics.getHeight() - 22)
end

return Lives