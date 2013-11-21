local UnitGraphics = require("UnitGraphics")

local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	newUnit.name = params.name
	
	local properties = UnitGraphics.getProperties(params.unitType)
	local imageSheet = graphics.newImageSheet(properties.fileName, properties.sheetData)
	
	newUnit.posX = params.posX
	newUnit.posY = params.posY
	newUnit.moves = params.moves
	newUnit.melee = params.melee
	newUnit.anim = display.newSprite(imageSheet, properties.sequenceData)
	newUnit.anim:setReferencePoint(display.TopLeftReferencePoint)
	newUnit.anim.x = (params.posX * 32) + 32
	newUnit.anim.y = (params.posY * 32) + 60
	newUnit.anim:play()
	newUnit.group = display.newGroup()
	
	setmetatable(newUnit, Unit)
	return newUnit
end

return Unit