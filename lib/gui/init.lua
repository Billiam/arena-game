local gui = require('lib.gui.gui')
local Button = require('lib.gui.button')
local Label = require('lib.gui.label')

local Scene = require('lib.gui.scene')

gui.setStylesheet(require('lib.gui.styles.stylesheet'))
gui.register('scene', Scene)
gui.register('button', Button)
gui.register('label', Label)


return gui