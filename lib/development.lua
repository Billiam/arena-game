local Resource = require('resource')
local lurker = require('vendor.lurker')
local Game = Resource.state.game
local Input = require('lib.input')

_G.inspect = require('vendor.inspect')

lurker.quiet = false
lurker.interval = 1

lurker.postswap = function(f)
  Resource.reload()
end

local oldUpdate = love.update
function love.update(...)
  lurker.update()

  oldUpdate(...)
end

local oldGameUpdate = Game.update
function Game.update(...)
  if Input.key.wasClicked('f1') then
    Game.nextWave()
  end

  if Input.key.wasClicked('f2') then
    Game.restartWave()
  end

  if Input.key.wasClicked('f3') then
    Game.dtModifier = Game.dtModifier == 1 and 0 or 1
  end

  if Input.key.wasClicked('f5') then
    Game.showHitboxes = not Game.showHitboxes
  end
  
  oldGameUpdate(...)
end

function table_print(...)
  print(inspect(...))
end