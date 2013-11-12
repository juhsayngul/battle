local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	newUnit.name = params.name
	newUnit.posX = params.posX
	newUnit.posY = params.posY
	newUnit.rect = display.newRect((params.posX * 32) + 32, (params.posY * 32) + 60, 32, 32)
	newUnit.rect:setFillColor(255, 90, 0)
	newUnit.group = display.newGroup()
	setmetatable(newUnit, Unit)
	print (newUnit.name .. " created!")
	return newUnit
end

return Unit