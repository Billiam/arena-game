local gui = require('lib.gui.gui')
local Button = require('lib.gui.button')
local Scene = require('lib.gui.scene')

gui.setStylesheet(require('lib.gui.styles.stylesheet'))
gui.register('scene', Scene)
gui.register('button', Button)

return gui