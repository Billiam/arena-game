return function(barrier, person, collision)
  if barrier.isAlive then
    person.angle = math.atan2(collision.normal.y, collision.normal.x)
  end
end