local Person = {
  type = 'person_view'
}
Person.mt = {__index = Person }

function Person.create()
  local instance = {}
  setmetatable(instance, Person.mt)
  return instance
end

function Person:render(person)
  love.graphics.push()
  love.graphics.translate(person.position.x + person.width / 2, person.position.y + person.height / 2)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('fill', -person.width/2, -person.height/2, person.width, person.height)

  love.graphics.rotate(person.angle + math.pi/2)
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.polygon(
    'fill',
    0, -person.height/2,
    -person.width/2, person.height/2,
    person.width/2, person.height/2
  )
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Person