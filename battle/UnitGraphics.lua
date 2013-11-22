local UnitGraphics = {}

local infantry_f = {}
infantry_f.sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 36}
infantry_f.fileName = "assets/infantry_f_anim.png"
infantry_f.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2, 3, 2},
		time = 500,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {4, 5, 6, 5},
		time = 500,
		loopCount = 0
	}
}

local tank_f = {}
tank_f.sheetData = {width = 32, height = 32, numFrames = 4, sheetContentWidth = 128, sheetContentHeight = 32}
tank_f.fileName = "assets/tank_f_anim.png"
tank_f.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2},
		time = 250,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {3, 4},
		time = 250,
		loopCount = 0
	}
}

local heli_f = {}
heli_f.sheetData = {width = 32, height = 32, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 32}
heli_f.fileName = "assets/heli_f_anim.png"
heli_f.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2, 1, 3},
		time = 200,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {6, 5, 6, 4},
		time = 200,
		loopCount = 0
	}
}

local cannon_f = {}
cannon_f.sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetcontentHeight = 36}
cannon_f.fileName = "assets/cannon_f_anim.png"
cannon_f.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2, 3, 2},
		time = 500,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {4, 5, 6, 5},
		time = 500,
		loopCount = 0
	}
}

local infantry_e = {}
infantry_e.sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 36}
infantry_e.fileName = "assets/infantry_e_anim.png"
infantry_e.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2, 3, 2},
		time = 500,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {4, 5, 6, 5},
		time = 500,
		loopCount = 0
	}
}

local tank_e = {}
tank_e.sheetData = {width = 32, height = 32, numFrames = 4, sheetContentWidth = 128, sheetContentHeight = 32}
tank_e.fileName = "assets/tank_e_anim.png"
tank_e.sequenceData = 
{
	{
		name = "idle_right",
		frames = {1, 2},
		time = 250,
		loopCount = 0
	},
	{
		name = "idle_left",
		frames = {3, 4},
		time = 250,
		loopCount = 0
	}
}

local properties = {}
properties["infantry_e"] = infantry_e
properties["infantry_f"] = infantry_f
properties["tank_e"] = tank_e
properties["tank_f"] = tank_f
properties["heli_f"] = heli_f
properties["cannon_f"] = cannon_f

function UnitGraphics.getProperties(unitType)
	return properties[unitType]
end

return UnitGraphics