require('lib.debug')

local Resource = require('resource')
local State = require('vendor.h.gamestate')
require('vendor.slam')
require('lib.graphics')
require('lib.vector')

local Input = require('lib.input')

function love.load()
  State.switch(Resource.state.title)
  --  initializeAudio()  
end

function love.draw()
  State.current().draw()
end

function love.update(dt)
  State.current().update(dt)
  Input.clear()
end