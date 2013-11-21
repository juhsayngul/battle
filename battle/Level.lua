local Board = require( "Board" )
local BG = require( "BG" )
local Unit = require ("Unit")
local Menu = require ("Menu")

local Level = {}
Level.__index = Level

local getUnits, getGroup

function Level.new(params)
	local newLevel = {}
	local i
	
	newLevel.group = display.newGroup()
	
	newLevel.bg = BG.new(params.bgParams)
	newLevel.board = Board.new(params.boardParams)
	
	newLevel.unit = getUnits(params.unitParams)
	newLevel.unitGroup = getGroup(newLevel.unit)
	newLevel.enemy = getUnits(params.enemyParams)
	newLevel.enemyGroup = getGroup(newLevel.enemy)
	
	newLevel.group:insert(newLevel.unitGroup)
	newLevel.group:insert(newLevel.enemyGroup)
	newLevel.group:insert(newLevel.board.group)
	newLevel.group:insert(newLevel.bg.group)
	
	newLevel.unitGroup:toBack()
	newLevel.enemyGroup:toBack()
	newLevel.board.group:toBack()
	newLevel.bg.group:toBack()
	
	setmetatable(newLevel, Level)
	return newLevel
end

getUnits = function (params)
	local i
	local unit = {}
	
	for i in pairs (params) do
		unit[i] = Unit.new(params[i])
	end
	
	return unit
end

getGroup = function (unitArray)
	local i
	local group = display.newGroup()
	
	for i in pairs (unitArray) do
		group:insert(unitArray[i].anim)
	end
	
	return group
end

return Level