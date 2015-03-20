local Resource = require('resource')

return {
  label = {
    color = {0, 0, 0, 160},
    font = Resource.font.pressstart2p[18],
  },
  [".menu"] = {
    color = {42, 52, 40, 255},
    font = Resource.font.pressstart2p[18],
    text_shadow = {3, 3, {0, 0, 0, 50}}
  },
  [".menu:hover"] = {
    color = {0, 0, 0, 255},
    background = {0, 0, 0, 15 },
    text_shadow = false
  },
  [".overlay"] = {
    color = { 0, 0, 0, 50},
    background = {255, 255, 255, 0},
  },
  [".overlay:hover"] = {
    color = { 0, 0, 0, 220},
    background = { 0, 0, 0, 10 }
  },
  ["button.option"] = {
    font = Resource.font.pressstart2p[18],
    color = {0, 0, 0, 160}
  },
  ["button.option:hover"] = {
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