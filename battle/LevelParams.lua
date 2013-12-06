local LevelParams = {}
LevelParams.__index = LevelParams

local _W, _H = display.contentWidth, display.contentHeight
local params = {}

params["1: Don't back down"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 0, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 7, y = 0}}
				}
}

params["2: Tiananmen Square"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "tank_f", pos = {x = 1, y = 6}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 6, y = 1}}
				}
}

params["3: That's not fair"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 2, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 2, y = 0}},
					{unitType = "infantry_e", pos = {x = 5, y = 0}}
				}
}

params["4: Horsey!"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cavalry_f", pos = {x = 0, y = 7}}
				},
	enemyParams = {
					{unitType = "cavalry_e", pos = {x = 7, y = 0}}
				}
}

params["5: Welcome to Earth"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cannon_f", pos = {x = 1, y = 7}},
					{unitType = "heli_f", pos = {x = 3, y = 7}},
					{unitType = "tank_f", pos = {x = 5, y = 7}}
				},
	enemyParams = {
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 4, y = 0}},
					{unitType = "cannon_e", pos = {x = 6, y = 0}}
				}
}

params["6: Calling for backup!"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 5, y = 5}},
					{unitType = "cannon_f", pos = {x = 0, y = 7}},
					{unitType = "tank_f", pos = {x = 2, y = 7}},
					{unitType = "infantry_f", pos = {x = 5, y = 7}},
					{unitType = "heli_f", pos = {x = 7, y = 7}},
					{unitType = "cavalry_f", pos = {x = 4, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 5, y = 4}},
					{unitType = "infantry_e", pos = {x = 7, y = 0}},
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 5, y = 0}},
					{unitType = "cannon_e", pos = {x = 0, y = 0}},
					{unitType = "cavalry_e", pos = {x = 4, y = 0}}
				}
}

params["7: WOAH! Look out!"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 2, y = 7}},
					{unitType = "infantry_f", pos = {x = 5, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 0, y = 0}},
					{unitType = "infantry_e", pos = {x = 1, y = 0}},
					{unitType = "infantry_e", pos = {x = 2, y = 0}},
					{unitType = "infantry_e", pos = {x = 3, y = 0}},
					{unitType = "infantry_e", pos = {x = 4, y = 0}},
					{unitType = "infantry_e", pos = {x = 5, y = 0}},
					{unitType = "infantry_e", pos = {x = 6, y = 0}},
					{unitType = "infantry_e", pos = {x = 7, y = 0}},
					{unitType = "infantry_e", pos = {x = 0, y = 1}},
					{unitType = "infantry_e", pos = {x = 1, y = 1}},
					{unitType = "infantry_e", pos = {x = 2, y = 1}},
					{unitType = "infantry_e", pos = {x = 3, y = 1}},
					{unitType = "infantry_e", pos = {x = 4, y = 1}},
					{unitType = "infantry_e", pos = {x = 5, y = 1}},
					{unitType = "infantry_e", pos = {x = 6, y = 1}},
					{unitType = "infantry_e", pos = {x = 7, y = 1}}
				}
}

params["8: Vaguely familiar..."] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 0, y = 6}},
					{unitType = "infantry_f", pos = {x = 1, y = 6}},
					{unitType = "infantry_f", pos = {x = 2, y = 6}},
					{unitType = "infantry_f", pos = {x = 3, y = 6}},
					{unitType = "infantry_f", pos = {x = 4, y = 6}},
					{unitType = "infantry_f", pos = {x = 5, y = 6}},
					{unitType = "infantry_f", pos = {x = 6, y = 6}},
					{unitType = "infantry_f", pos = {x = 7, y = 6}},
					{unitType = "cavalry_f", pos = {x = 0, y = 7}},
					{unitType = "tank_f", pos = {x = 1, y = 7}},
					{unitType = "tank_f", pos = {x = 2, y = 7}},
					{unitType = "heli_f", pos = {x = 3, y = 7}},
					{unitType = "cannon_f", pos = {x = 4, y = 7}},
					{unitType = "tank_f", pos = {x = 5, y = 7}},
					{unitType = "tank_f", pos = {x = 6, y = 7}},
					{unitType = "cavalry_f", pos = {x = 7, y = 7}}
				},
	enemyParams = {
					{unitType = "cavalry_e", pos = {x = 0, y = 0}},
					{unitType = "tank_e", pos = {x = 1, y = 0}},
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 3, y = 0}},
					{unitType = "cannon_e", pos = {x = 4, y = 0}},
					{unitType = "tank_e", pos = {x = 5, y = 0}},
					{unitType = "tank_e", pos = {x = 6, y = 0}},
					{unitType = "cavalry_e", pos = {x = 7, y = 0}},
					{unitType = "infantry_e", pos = {x = 0, y = 1}},
					{unitType = "infantry_e", pos = {x = 1, y = 1}},
					{unitType = "infantry_e", pos = {x = 2, y = 1}},
					{unitType = "infantry_e", pos = {x = 3, y = 1}},
					{unitType = "infantry_e", pos = {x = 4, y = 1}},
					{unitType = "infantry_e", pos = {x = 5, y = 1}},
					{unitType = "infantry_e", pos = {x = 6, y = 1}},
					{unitType = "infantry_e", pos = {x = 7, y = 1}}
				}
}

params["9: Can't trust anyone"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "heli_f", pos = {x = 3, y = 4}}
				},
	enemyParams = {
					{unitType = "heli_f", pos = {x = 1, y = 3}},
					{unitType = "heli_f", pos = {x = 1, y = 5}},
					{unitType = "heli_e", pos = {x = 6, y = 4}}
				}
}

params["10: Have fun with that"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cavalry_f", pos = {x = 1, y = 6}}
				},
	enemyParams = {
					{unitType = "cavalry_e", pos = {x = 2, y = 0}},
					{unitType = "cavalry_e", pos = {x = 4, y = 0}},
					{unitType = "cavalry_e", pos = {x = 6, y = 0}}
				}
}

params["2P-1"] = {
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

params["2P-2"] = {
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

params["2P-3"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cannon_f", pos = {x = 1, y = 7}},
					{unitType = "heli_f", pos = {x = 3, y = 7}},
					{unitType = "tank_f", pos = {x = 5, y = 7}}
				},
	enemyParams = {
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 4, y = 0}},
					{unitType = "cannon_e", pos = {x = 6, y = 0}}
				}
}

params["2P-4"] = {
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "infantry_f", pos = {x = 0, y = 6}},
					{unitType = "infantry_f", pos = {x = 1, y = 6}},
					{unitType = "infantry_f", pos = {x = 2, y = 6}},
					{unitType = "infantry_f", pos = {x = 3, y = 6}},
					{unitType = "infantry_f", pos = {x = 4, y = 6}},
					{unitType = "infantry_f", pos = {x = 5, y = 6}},
					{unitType = "infantry_f", pos = {x = 6, y = 6}},
					{unitType = "infantry_f", pos = {x = 7, y = 6}},
					{unitType = "cavalry_f", pos = {x = 0, y = 7}},
					{unitType = "tank_f", pos = {x = 1, y = 7}},
					{unitType = "tank_f", pos = {x = 2, y = 7}},
					{unitType = "heli_f", pos = {x = 3, y = 7}},
					{unitType = "cannon_f", pos = {x = 4, y = 7}},
					{unitType = "tank_f", pos = {x = 5, y = 7}},
					{unitType = "tank_f", pos = {x = 6, y = 7}},
					{unitType = "cavalry_f", pos = {x = 7, y = 7}}
				},
	enemyParams = {
					{unitType = "cavalry_e", pos = {x = 0, y = 0}},
					{unitType = "tank_e", pos = {x = 1, y = 0}},
					{unitType = "tank_e", pos = {x = 2, y = 0}},
					{unitType = "heli_e", pos = {x = 3, y = 0}},
					{unitType = "cannon_e", pos = {x = 4, y = 0}},
					{unitType = "tank_e", pos = {x = 5, y = 0}},
					{unitType = "tank_e", pos = {x = 6, y = 0}},
					{unitType = "cavalry_e", pos = {x = 7, y = 0}},
					{unitType = "infantry_e", pos = {x = 0, y = 1}},
					{unitType = "infantry_e", pos = {x = 1, y = 1}},
					{unitType = "infantry_e", pos = {x = 2, y = 1}},
					{unitType = "infantry_e", pos = {x = 3, y = 1}},
					{unitType = "infantry_e", pos = {x = 4, y = 1}},
					{unitType = "infantry_e", pos = {x = 5, y = 1}},
					{unitType = "infantry_e", pos = {x = 6, y = 1}},
					{unitType = "infantry_e", pos = {x = 7, y = 1}}
				}
}

function LevelParams.getLevelParams(whichLevel)
	return params[whichLevel]
end

return LevelParams