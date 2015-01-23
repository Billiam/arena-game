local Hitbox = {}

local function dottedLine(x1, y1, x2, y2, dash, gap)
  local dash = dash or 10
  local gap  = dash + (gap or 10)

  local steep = math.abs(y2-y1) > math.abs(x2-x1)
  if steep then
    x1, y1 = y1, x1
    x2, y2 = y2, x2
  end
  if x1 > x2 then
    x1, x2 = x2, x1
    y1, y2 = y2, y1
  end

  local dx = x2 - x1
  local dy = math.abs( y2 - y1 )
  local err = dx / 2
  local ystep = (y1 < y2) and 1 or -1
  local y = y1
  local maxX = x2
  local pixelCount = 0
  local isDash = true
  local lastA, lastB, a, b

  for x = x1, maxX do
    pixelCount = pixelCount + 1
    if (isDash and pixelCount == dash) or (not isDash and pixelCount == gap) then
      pixelCount = 0
      isDash = not isDash
      a = steep and y or x
      b = steep and x or y
      if lastA then
        love.graphics.line( lastA, lastB, a, b )
        lastA = nil
        lastB = nil
      else
        lastA = a
        lastB = b
      end
    end

    err = err - dy
    if err < 0 then
      y = y + ystep
      err = err + dx
    end
  end
end

function Hitbox.render(item)
  local hitbox = item.hitbox or item
  local size = 1
  local interval = 1

  love.graphics.push()

  love.graphics.setColor(229, 94, 162)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle('rough')

  dottedLine(
    hitbox.position.x,
    hitbox.position.y,
    hitbox.position.x,
    hitbox.position.y + hitbox.height,
    size,
    interval
  )
  dottedLine(
    hitbox.position.x,
    hitbox.position.y + hitbox.height,
    hitbox.position.x + hitbox.width,
    hitbox.position.y + hitbox.height,
    size,
    interval
  )
  dottedLine(
    hitbox.position.x + hitbox.width,
    hitbox.position.y,
    hitbox.position.x + hitbox.width,
    hitbox.position.y + hitbox.height,
    size,
    interval
  )
  dottedLine(
    hitbox.position.x,
    hitbox.position.y,
    hitbox.position.x + hitbox.width,
    hitbox.position.y,
    size,
    interval
  )

  love.graphics.pop()
end

return Hitbox