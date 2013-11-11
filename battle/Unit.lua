local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	newUnit.name = params.name
	newUnit.rect = display.newRect(params.posX, params.posY, 32, 32)
	newUnit.rect:setFillColor(0, 0, 160)
	newUnit.group = display.newGroup()
	setmetatable(newUnit, Unit)
	return newUnit
end

return Unit