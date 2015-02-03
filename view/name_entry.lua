local Resource = require('resource')
local NameEntry = {}
NameEntry.__index = NameEntry

local function renderChar(text, position, hideUnderline)
  local offset = (position - 1) * 35
  local character = text[position]
  love.graphics.setFont(Resource.font.noto_regular[20])
  
  if character then
    if character == text.DELETE then
      love.graphics.draw(Resource.image['icon/delete'], 7 + offset, -22)
    elseif character == text.END then
      love.graphics.draw(Resource.image['icon/enter'], 7 + offset, -20)
    else
      love.graphics.printf(character, offset, -30, 30, 'center')
    end
  end
  
  if not hideUnderline then
    if position == text.selected then
      love.graphics.setColor(255, 0, 0, 255)
    else
      love.graphics.setColor(255, 255, 255, 255)
    end
    love.graphics.rectangle('fill', offset, 0, 30, 4)
  end
end

function NameEntry.render(text)
  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth()/2 - 50, love.graphics.getHeight() / 2 + 50)

  for i=1,text.limit + 1 do
    renderChar(text, i, i == text.limit + 1)
  end
  love.graphics.pop()
end

return NameEntry