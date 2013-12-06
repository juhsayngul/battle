display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"
local sfx = require("sfx")

audio.setVolume(sfx.volume.LOUD)

local options = {
	effect = "fade",
	time = 400
}

storyboard.gotoScene("Title-Screen", options)