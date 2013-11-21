local Board = require( "Board" )
local BG = require( "BG" )
local Unit = require ("Unit")
-- local Enemy = require ("Enemy")

local Level = {}
Level.__index = Level

function Level.new(params)
	local newLevel = {}
	local i
	
	newLevel.unit = {}
	newLevel.enemy = {}
	newLevel.bg = BG.new(params.bgParams)
	newLevel.board = Board.new(params.boardParams)
	for i in pairs(params.unitParams) do
		newLevel.unit[i] = Unit.new(params.unitParams[i])
	end
	for i in pairs(params.enemyParams) do
		newLevel.enemy[i] = Unit.new(params.enemyParams[i])
	end
	
	newLevel.group = display.newGroup()
	
	newLevel.group:insert(newLevel.board.group)
	newLevel.group:insert(newLevel.bg.group)
	newLevel.board.group:toBack()
	newLevel.bg.group:toBack()
	setmetatable(newLevel, Level)
	
	return newLevel
end

return Level