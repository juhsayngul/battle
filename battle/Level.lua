local Board = require( "Board" )
local BG = require( "BG" )
local Unit = require ("Unit")

local Level = {}
Level.__index = Level

function Level.new(params)
	local newLevel = {}
	newLevel.bg = BG.new(params.bgParams)
	newLevel.board = Board.new(params.boardParams)
	newLevel.unit = Unit.new(params.unitParams)
	
	newLevel.name = params.name
	
	newLevel.group = display.newGroup()
	
	newLevel.group:insert(newLevel.board.group)
	newLevel.group:insert(newLevel.bg.group)
	newLevel.board.group:toBack()
	newLevel.bg.group:toBack()
	setmetatable(newLevel, Level)
	
	return newLevel
end

function Level:listen()
	print (self.name.." now listening.")
	self.bg:listen()
	self.board:listen()
end

return Level