local Board = {}
Board.__index = Board

function Board.new(params)
	local newBoard = {}
	newBoard.name = params.name
	newBoard.group = display.newGroup()
	setmetatable(newBoard, Board)
	return newBoard
end

function Board:listen()
	print (self.name.." now listening.")
end

return Board