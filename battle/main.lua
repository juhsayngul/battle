display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"

local _W, _H = display.contentWidth, display.contentHeight

local levelParams = {
	levelName = "Level 1",
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	unitParams = {
					{unitType = "infantry_f", pos = {x = 0, y = 0}},
					{unitType = "tank_f", pos = {x = 7, y = 0}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 7, y = 7}},
					{unitType = "tank_e", pos = {x = 0, y = 7}}
				}
}

local options = {params = levelParams}

storyboard.gotoScene("Level", options)