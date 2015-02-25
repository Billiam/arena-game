local Resource = require('resource')

return {
  button = {
    background = {200, 200, 200, 255},
    color = {0, 0, 0, 255},
  },
  ["button:hover"] = {
    background = {0, 0, 0, 255 },
    color = { 255, 255, 255, 255},
  },
  ["button.menu"] = {
    background = {143, 167, 136, 255},
    font = Resource.font.noto_black[20]
  },
  ["button.overlay"] = {
    background = {255, 255, 255, 0},
  },
  ["button.overlay:hover"] = {
    background = { 255, 255, 255, 0 }
  },
  ["button.previous"] = {
    image = Resource.image['ui/left']
  },
  ["button.next"] = {
    image = Resource.image['ui/right']
  }
}