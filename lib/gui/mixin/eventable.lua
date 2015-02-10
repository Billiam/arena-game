local Mixin = require('lib.mixin')

local Eventable = {}
setmetatable(Eventable, {__index = Mixin})

function Eventable:getEvents()
  self.events = self.events or {}

  return self.events
end

function Eventable:getEvent(name)
  local list = self:getEvents()
  list[name] = list[name] or {}
  
  return list[name]
end

function Eventable:off(eventName, callback)
  if callback then
    for i=#self:getEvent(eventName),1,-1 do
      if self.events[eventName][i] == v then
        table.remove(self.events[eventName], i)
      end
    end
  else
    self:getEvents()[eventName] = {}
  end
end

function Eventable:on(eventName, callback)
  table.insert(self:getEvent(eventName), callback)
end

function Eventable:trigger(eventName, target)
  local propagate = true

  for i,callback in ipairs(self:getEvent(eventName)) do
    if callback(self) == false then
      propagate = false
      break
    end
  end
  
  if propagate and self.parent and self.parent.trigger then
    self.parent:trigger(eventName, self)
  end
  
end

return Eventable