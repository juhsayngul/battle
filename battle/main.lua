display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"
local sfx = require("sfx")

-- no need to reserve channels with the pseudo-global functionality. see sfx.lua.

local options = {
	effect = "fade",
	time = 400
}

storyboard.gotoScene("Title-Screen", options)