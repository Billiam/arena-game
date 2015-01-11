local Grunt = {}

function Grunt.render(Grunts)
  love.graphics.setColor(255, 0, 0, 255)

  for i,Grunt in ipairs(Grunts) do
    love.graphics.rectangle("fill", Grunt.position.x, Grunt.position.y, Grunt.width, Grunt.height)
  end
  
  love.graphics.setColor(255,255,255,255)
end

return Grunt