local Resource = require('resource')
local State = require('vendor.h.gamestate')
require('vendor.slam')
require('lib.graphics')
require('lib.vector')

local Input = require('lib.input')

function love.load(arg)
  for i,argument in ipairs(arg) do
    if argument == '--debug' then
      require('lib.development')
    end
  end

  State.switch(Resource.state.title)
end

function love.draw()
  State.current().draw()
end

function love.update(dt)
  State.current().update(dt)
  Input.clear()
end