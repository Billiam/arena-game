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

  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.line(0, 0, math.cos(person.angle) * 15, math.sin(person.angle) * 15)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.pop()
end

return Person