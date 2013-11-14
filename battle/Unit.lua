local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	local sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 36}
	local imageSheet = graphics.newImageSheet("infantry_anim.png", sheetData)
	local sequenceData = 
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
	newUnit.name = params.name
	newUnit.posX = params.posX
	newUnit.posY = params.posY
	newUnit.moves = params.moves
	newUnit.anim = display.newSprite(imageSheet, sequenceData)
	newUnit.anim:setReferencePoint(display.TopLeftReferencePoint)
	newUnit.anim.x = (params.posX * 32) + 32
	newUnit.anim.y = (params.posY * 32) + 60
	if newUnit.posX >= 4 then
		newUnit.anim:setSequence("idle_left")
	else
		newUnit.anim:setSequence("idle_right")
	end
	newUnit.anim:play()
	newUnit.group = display.newGroup()
	setmetatable(newUnit, Unit)
	return newUnit
end

return Unit