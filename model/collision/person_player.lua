return function(person, player)
  if player.isAlive and person.isAlive then
    person:rescue()
  end
end