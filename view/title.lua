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

  local w = img:getWidth()
  local h = img:getHeight()

  local sw = love.graphics.getWidth()
  local sh = love.graphics.getHeight()

  local scale = math.min(
    sw / w,
    sh*0.95 / h
  )
  if scale > 1 then
    scale = math.floor(scale * 2) / 2
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

return Title