local Board = {}
Board.__index = Board

function Board.new(params)
	local newBoard = {}
	local offsetX = 32
	local offsetY = 60
	newBoard.name = params.name
	for i = 0, 7 do
		for j = 0, 7 do
			newBoard.rect = display.newRect(offsetX + 32*j, offsetY + 32* i, 32, 32)
			newBoard.rect.strokeWidth = 2
			newBoard.rect:setFillColor(0, 0, 0, 0)
			newBoard.rect:setStrokeColor(255, 255, 255)
		end
	end
	newBoard.group = display.newGroup()
	setmetatable(newBoard, Board)
	return newBoard
end

function Board:listen()
	print (self.name.." now listening.")
end

return Board