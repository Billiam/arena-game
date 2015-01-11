local Input = require('lib.input')

State = {}

function State.update()
end

function State.draw()
end

function State.init()
end

function State.enter(previous)
  Input.forget()
end

function State.leave()
end

function State.resume()
  Input.forget()
end

return State