local Controller = require('lib.controller')
local Input = require('lib.input')

local ScoreInput = {}
ScoreInput.mt = { __index = ScoreInput }

function ScoreInput.create()
  local instance = {}

  setmetatable(instance, ScoreInput.mt)

  return instance
end

function ScoreInput:update(entry)
  for char in Input.text() do
    entry:type(char)
  end

  if Input.key.wasPressed('backspace') then
    entry:delete()
  end

  if Controller.nextLetter() then
    entry:up()
  end

  if Controller.previousLetter() then
    entry:down()
  end

  if Controller.menuBack() then
    entry:delete()
  end

  if Controller.menuSelect() then
    entry:confirm()
  end
end

return ScoreInput
