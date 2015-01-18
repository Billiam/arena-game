local Resource = require('resource')
local Title = {}

local duration = 0.75

local function quadEase(t, b, c, d)
  t = t / (d/2);
  if (t < 1) then
    return c/2*math.pow(t,4)+ b;
  end

  t = t - 2;
  return -c/2 * (math.pow(t,4) - 2) + b;
end

function Title.render(time)
  local img = Resource.image.title
  local easing

  if time > duration then
    easing = 1
  else
    easing = quadEase(time, 0, 1, duration )
  end

  love.graphics.draw(
    img,
    love.graphics.getWidth()/2,
    love.graphics.getHeight() - 80,
    0,
    easing,
    easing,
    img:getWidth()/2 - 4,
    img:getHeight() - 10
  )
end

return Title