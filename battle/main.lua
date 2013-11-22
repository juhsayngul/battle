display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"

local options = {
	effect = "fade",
	time = 400
}

storyboard.gotoScene("Title-Screen", options)