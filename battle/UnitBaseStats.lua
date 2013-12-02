local UnitBaseStats = {}
UnitBaseStats.__index = UnitBaseStats

local infantry = {
	melee = {
		atk = 5,
		def = 3,
		rng = 1
	},
	ranged = {
		atk = 0,
		def = 1,
		rng = 0
	},
	health = 4,
	moves = 3
}

local tank = {
	melee = {
		atk = 4,
		def = 4,
		rng = 1
	},
	ranged = {
		atk = 5,
		def = 3,
		rng = 3
	},
	health = 5,
	moves = 2
}

local heli = {
	melee = {
		atk = 0,
		def = 10,
		rng = 1,
	},
	ranged = {
		atk = 4,
		def = 0,
		rng = 5
	},
	health = 3,
	moves = 5
}

local cannon = {
	melee = {
		atk = 0,
		def = 0,
		rng = 1
	},
	ranged = {
		atk = 10,
		def = 2,
		rng = 5
	},
	health = 5,
	moves = 2
}

local cavalry = {
	melee = {
		atk = 10,
		def = 1,
		rng = 1
	},
	ranged = {
		atk = 5,
		def = 3,
		rng = 3
	},
	health = 10,
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