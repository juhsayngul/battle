local BG = {}
BG.__index = BG

function BG.new(params)
	local newBG = {}
	newBG.group = display.newGroup()
	
	newBG.shape = display.newRect(params.pos.x, params.pos.y, params.length.x, params.length.y)
	newBG.shape:setFillColor(0, 0 , 0)
	newBG.group:insert(newBG.shape)
	
	setmetatable(newBG, BG)
	return newBG
end

return BG