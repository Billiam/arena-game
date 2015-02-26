local Resource = require('resource')

return {
  label = {
    color = {0, 0, 0, 160}
  },
  [".menu"] = {
    color = {255, 255, 255, 255},
    font = Resource.font.noto_black[20]
  },
  [".menu:hover"] = {
    background = {0, 0, 0, 255 },
  },
  [".overlay"] = {
    color = { 255, 255, 255, 255},
    background = {255, 255, 255, 0},
  },
  [".overlay:hover"] = {
    background = { 0, 0, 0, 160 }
  },
  [".option"] = {
    color = {0, 0, 0, 160}
  },
  [".option:hover"] = {
    background = {0, 0, 0, 10},
    color = {0, 0, 0, 255}
  },
  ["button.previous"] = {
    image_opacity = 0.5,
    image = Resource.image['ui/left']
  },
  ["button.previous:hover"] = {
    image_opacity = 1
  },
  ["button.next"] = {
    image_opacity = 0.5,
    image = Resource.image['ui/right']
  },
  ["button.next:hover"] = {
    image_opacity = 1
  },
}