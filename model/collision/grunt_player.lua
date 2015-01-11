local beholder = require('vendor.beholder')

return function(grunt, player)
  if player.isAlive then
    print('killing player')
    
    player.isAlive = false
    beholder.trigger('PLAYERDEATH', player, grunt)
  end
end