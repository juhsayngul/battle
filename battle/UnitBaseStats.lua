local UnitBaseStats = {}
UnitBaseStats.__index = UnitBaseStats

local infantry = {
	melee = {
		atk = 4,
		def = 2,
		rng = 1
	},
	ranged = {
		atk = 0,
		def = 1,
		rng = 1
	},
	health = 4,
	moves = 3
}

local tank = {
	melee = {
		atk = 4,
		def = 3,
		rng = 1
	},
	ranged = {
		atk = 5,
		def = 3,
		rng = 2
	},
	health = 6,
	moves = 3
}

local heli = {
	melee = {
		atk = 0,
		def = 4,
		rng = 1,
	},
	ranged = {
		atk = 4,
		def = 1,
		rng = 5
	},
	health = 5,
	moves = 5
}
	
local cannon = {
	melee = {
		atk = 0,
		def = 1,
		rng = 1
	},
	ranged = {
		atk = 6,
		def = 1,
		rng = 4
	},
	health = 3,
	moves = 2
}

local cavalry = {
	melee = {
		atk = 4,
		def = 2,
		rng = 1
	},
	ranged = {
		atk = 0,
		def = 4,
		rng = 3
	},
	health = 3,
	moves = 5
}

local base = {}
base["infantry_e"] = infantry
base["infantry_f"] = infantry
base["tank_e"] = tank
base["tank_f"] = tank
base["heli_f"] = heli
base["heli_e"] = heli
base["cannon_f"] = cannon
base["cannon_e"] = cannon
base["cavalry_f"] = cavalry
base["cavalry_e"] = cavalry

function UnitBaseStats.getBaseStats(unitType)
	return base[unitType]
end

return UnitBaseStats