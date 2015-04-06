return function(spheroid, wall, collision)
  if collision.normal.x == 0 then
    spheroid.velocity.y = 0
  else
    spheroid.velocity.x = 0
  end
end