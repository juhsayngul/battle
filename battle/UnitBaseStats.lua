local UnitBaseStats = {}
UnitBaseStats.__index = UnitBaseStats

local infantry = {
	melee = {
		atk = 5,
		def = 5,
		rng = 1
	},
	ranged = {
		atk = 0,
		def = 5,
		rng = 0
	},
	health = 5,
	moves = 5
}

local tank = {
	melee = {
		atk = 5,
		def = 5,
		rng = 1
	},
	ranged = {
		atk = 5,
		def = 5,
		rng = 5
	},
	health = 5,
	moves = 5
}

local base = {}
base["infantry_e"] = infantry
base["infantry_f"] = infantry
base["tank_e"] = tank
base["tank_f"] = tank

UnitBaseStats.base = base

function UnitBaseStats.getBaseStats(unitType)
	return UnitBaseStats.base[unitType]
end

return UnitBaseStats