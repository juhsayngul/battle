local LevelParams = {}
LevelParams.__index = LevelParams

local _W, _H = display.contentWidth, display.contentHeight
local params = {}

-- just an example level we're working with
params["Level 1"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 2, y = 7}},
					{unitType = "infantry_f", pos = {x = 5, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 2, y = 0}},
					{unitType = "infantry_e", pos = {x = 5, y = 0}}
				}
}

-- just another example to show how easily we can write new levels
params["Level 2"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 0, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 7, y = 0}}
				}
}

params["Level 3"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cannon_f", pos = {x = 0, y = 7}},
					{unitType = "tank_f", pos = {x = 2, y = 7}},
					{unitType = "infantry_f", pos = {x = 5, y = 7}},
					{unitType = "heli_f", pos = {x = 7, y = 7}},
					{unitType = "cavalry_f", pos = {x = 4, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 7, y = 0}},
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 5, y = 0}},
					{unitType = "cannon_e", pos = {x = 0, y = 0}},
					{unitType = "cavalry_e", pos = {x = 4, y = 0}}
				}
}

function LevelParams.getLevelParams(whichLevel)
	return params[whichLevel]
end

return LevelParams