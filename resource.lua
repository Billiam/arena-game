local Proxy = require('vendor.proxy')
local Resources = {}

function Resources.init()
  Resources.image = Proxy(function(k) return assert(love.graphics.newImage('assets/img/' .. k .. '.png')) end)
  Resources.state = Proxy(function(k) return assert(love.filesystem.load('states/' .. k .. '.lua'))() end)
  Resources.view = Proxy(function(k) return assert(love.filesystem.load('view/' .. k .. '.lua'))() end)
  Resources.audio = Proxy(function(k) return love.audio.newSource('assets/audio/' .. k .. '.ogg', 'static') end)
  Resources.font = Proxy(function(k) return Proxy(function(s) return love.graphics.newFont('assets/font/' .. k .. '.ttc', s) end) end)
end

function Resources.reload()
  Resources.init()
end

Resources.init()
return Resources