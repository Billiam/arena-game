local Proxy = require('vendor.proxy')
local Resources = {}

Resources.state = Proxy(function(k) return assert(love.filesystem.load('states/' .. k .. '.lua'))() end)
Resources.view = Proxy(function(k) return assert(love.filesystem.load('view/' .. k .. '.lua'))() end)
Resources.audio = Proxy(function(k) return love.audio.newSource('assets/audio/' .. k .. '.ogg', 'static') end)

return Resources