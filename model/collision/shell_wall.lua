return function(shell, wall, collision)
  local normal = Vector(collision.normal.y, collision.normal.x)
  shell.velocity = shell.velocity:mirrorOn(normal)
end