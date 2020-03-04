if not class then
	class = require('vendor.middleclass')
end

ikkuna = {}
ikkuna.font = love.graphics.newFont('res/Verdana.ttf')

-- Const
ikkuna.TextAlign = {}
ikkuna.TextAlign.Left = 1
ikkuna.TextAlign.Right = 2
ikkuna.TextAlign.Center = 3

-- Util
require('util.math')
require('util.table')

-- Style
require('style.stream')
require('style.token')
require('style.lexer')

-- Base
require('gui.event')
require('gui.display')
require('gui.widget')

-- Widgets
require('widgets.checkbox')
require('widgets.progressbar')
require('widgets.radiobox')
require('widgets.radiogroup')
require('widgets.label')
