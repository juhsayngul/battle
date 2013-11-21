local BG = {}
BG.__index = BG

function BG.new(params)
	local newBG = {}
	newBG.group = display.newGroup()
	
	newBG.shape = display.newRect(params.posX, params.posY, params.x, params.y)
	newBG.shape:setFillColor(0, 0 , 0)
	newBG.group:insert(newBG.shape)
	
	setmetatable(newBG, BG)
	return newBG
end

return BG