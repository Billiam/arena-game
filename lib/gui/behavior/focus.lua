local Focus = {}

local events = {
  hover = function(target)
    target:addStyle(':hover')
  end,

  leave = function(target)
    target:removeStyle(':hover')
  end,

  focus = function(target)
    target:addStyle(':focus')
  end,

  blur = function(target)
    target:removeStyle(':focus')
  end
}

function Focus.register(instance)
  for name,callback in pairs(events) do
    instance:on(name, callback)
  end
end

return Focus