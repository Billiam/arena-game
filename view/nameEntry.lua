local Resource = require('resource')
local NameEntry = {}
NameEntry.__index = NameEntry

local function renderChar(text, position, selected)
  local offset = (position - 1) * 35
  local character = text[position]

  if character then
    if character == text.DELETE then
      love.graphics.draw(Resource.image['icon/delete'], 7 + offset, -20)
    elseif character == text.END then
      love.graphics.draw(Resource.image['icon/enter'], 7 + offset, -20)
    else
      love.graphics.print(string.upper(character), 7 + offset, -20)
    end
  end
  
  if position == selected then
    love.graphics.setColor(255, 0, 0, 255)
  else
    love.graphics.setColor(255, 255, 255, 255)
  end
  love.graphics.rectangle('fill', offset, 0, 30, 4)
end

function NameEntry.render(text)
  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth()/2 - 100, love.graphics.getHeight() / 2)

  for i=1,text.limit + 1 do
    renderChar(text, i, text.selected)
  end
  love.graphics.pop()
end

return NameEntry