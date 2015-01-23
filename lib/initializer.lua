local requireTree = require('vendor.requireTree')
local Initializer = {}

function Initializer.init()
  requireTree('initializer', true)
end

return Initializer