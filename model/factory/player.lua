local View = require('view.player')

local player = require('model.player')

local Firing = require('component.firing')
local PlayerInput = require('component.player_input')
local Health = require('component.health')

local Gun = require('model.gun')

return function(position, entities, controllerIndex)
  local health = Health.create()
  local entity = player.create(position, health)
  entity:setGun(Gun.auto())

  if controllerIndex then
    entity:add(PlayerInput.create(1))
  end

  if entities then
    entity:add(Firing.create(entities))
  end

  entity:add(View.create())

  return entity
end