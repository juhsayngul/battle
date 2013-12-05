display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"

local options = {
	effect = "fade",
	time = 400
}
audio.reserveChannels(1)
audio.setVolume(0.5, {channel=1})

storyboard.gotoScene("Title-Screen", options)