local Geometry = {
  CIRCLE = math.pi * 2,
  HALFCIRCLE = math.pi,
  QUARTERCIRCLE = math.pi * 0.5,
}

function Geometry.radianDiff(a1, a2)
  return (a1 - a2 + Geometry.HALFCIRCLE) % Geometry.CIRCLE - Geometry.HALFCIRCLE
end

function Geometry.lineAngle(p1, p2)
  return (p1 - p2):angleTo()
end

return Geometry