local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	newUnit.name = params.name
	local sheetData = nil
	local imageSheet = nil
	local sequenceData = nil
	if newUnit.name == "Infantry" then
		sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 36}
		imageSheet = graphics.newImageSheet("assets/infantry_anim.png", sheetData)
		sequenceData = 
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
	elseif newUnit.name == "Tank" then
		sheetData = {width = 32, height = 32, numFrames = 4, sheetContentWidth = 128, sheetContentHeight = 32}
		imageSheet = graphics.newImageSheet("assets/tank_anim.png", sheetData)
		sequenceData = 
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
	end
	newUnit.posX = params.posX
	newUnit.posY = params.posY
	newUnit.moves = params.moves
	newUnit.melee = params.melee
	newUnit.anim = display.newSprite(imageSheet, sequenceData)
	newUnit.anim:setReferencePoint(display.TopLeftReferencePoint)
	newUnit.anim.x = (params.posX * 32) + 32
	newUnit.anim.y = (params.posY * 32) + 60
	newUnit.anim:play()
	newUnit.group = display.newGroup()
	setmetatable(newUnit, Unit)
	return newUnit
end

return Unit