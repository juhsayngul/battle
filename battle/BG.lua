local BG = {}
BG.__index = BG

function BG.new(params)
	local newBG = {}
	newBG.name = params.name
	newBG.shape = display.newRect(params.posX, params.posY, params.x, params.y)
	newBG.shape:setFillColor(255, 0 , 0)
	newBG.group = display.newGroup()
	setmetatable(newBG, BG)
	return newBG
end

function BG:listen()
	print (self.name.." now listening.")
end

return BG