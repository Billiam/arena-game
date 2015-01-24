require('app')
require ('lib.callbacks')

local Initializer = require('lib.initializer')
local Resource = require('resource')
local State = require('vendor.h.gamestate')
local Input = require('lib.input')

function love.load(arg)
  for i,argument in ipairs(arg) do
    if argument == '--debug' then
      App.development = true
    end
  end

  Initializer.init()

  State.switch(Resource.state.title)
end

function love.resize(...)
  State.current().resize(...)
end

function love.draw()
  State.current().draw()
end

function love.update(dt)
  Input.update()
  State.current().update(dt)
  Input.clear()
end