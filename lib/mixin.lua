local Mixin = {}

function Mixin:mixInto(klass)
  for property,value in pairs(self) do
    if property ~= 'mixInto' then
      klass[property] = value
    end
  end
end

return Mixin