local Resource = require('resource')
local Title = {}
local font = love.graphics.newFont(24)

local duration = 0.75

local function quadEase(t, b, c, d)
  t = t / (d/2);
  if (t < 1) then
    return c/2*math.pow(t,4)+ b;
  end

  t = t - 2;
  return -c/2 * (math.pow(t,4) - 2) + b;
end

function Title.renderLogo(time)
  local img = Resource.image.title

  local w = img:getWidth()
  local h = img:getHeight()

  local sw = love.graphics.getWidth()
  local sh = love.graphics.getHeight()

  local scale = math.min(
    sw / w,
    sh*0.95 / h
  )
  if scale > 1 then
    scale = math.floor(scale * 4) / 4
  end

  local easing = scale

  if time <= duration then
    easing = easing * quadEase(time, 0, 1, duration)
  end

  love.graphics.draw(
    img,
    sw/2,
    sh * 0.95,
    0,
    easing,
    easing,
    w/2 - 4,
    h - 10
  )
end

function Title.renderMenu(menu)
  menu:setDimensions(300, 80, 0, 30)
  local menuHeight = menu:height()
  local previousFont = love.graphics.getFont()

  love.graphics.push()

  love.graphics.setFont(font)
  love.graphics.translate(love.graphics.getWidth() - 300, love.graphics.getHeight()/3)

  love.graphics.setColor(0, 0, 0, 125)
  love.graphics.rectangle('fill', -20, 20, 320, menuHeight + 50)

  love.graphics.setColor(143, 167, 136, 255)
  love.graphics.rectangle('fill', 0, 0, 300, menuHeight + 50)

  menu:draw(0, 50, {39, 39, 39, 255}, {39, 39, 39, 255}, {113, 150, 103, 255})

  love.graphics.pop()
  love.graphics.setFont(previousFont)
end

function Title.render(time, menu)
  Resource.view.background.render(love.graphics.getWidth(), love.graphics.getHeight())
  Title.renderLogo(time)
  Title.renderMenu(menu)
end

return Title