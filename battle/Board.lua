local Board = {}
Board.__index = Board

local offsetX = 32
local offsetY = 60

local isSomeUnitAt, whichUnitAt, initRangeTiles, activateTile, combineUnitLists

function Board.new(params)
	local newBoard = {}
	newBoard.group = display.newGroup()
	newBoard.rangeTileMoveGroup = display.newGroup()
	newBoard.rangeTileAttackGroup = display.newGroup()
	newBoard.rangeTileGroup = display.newGroup()
	
	newBoard.rangeTileGroup:insert(newBoard.rangeTileMoveGroup)
	newBoard.rangeTileGroup:insert(newBoard.rangeTileAttackGroup)
	
	newBoard.rangeTilesMove = {}
	newBoard.rangeTilesAttack = {}
	
	local i, j
	for i = 0, 7 do
		for j = 0, 7 do
			newBoard.rect = display.newRect(offsetX + 32*j, offsetY + 32* i, 32, 32)
			newBoard.rect.strokeWidth = 2
			newBoard.rect:setFillColor(0, 0, 0, 0)
			newBoard.rect:setStrokeColor(255, 255, 255)
			newBoard.group:insert(newBoard.rect)
		end
	end
	
	
	setmetatable(newBoard, Board)
	return newBoard
end

function Board:drawMoveRange(selectedUnit, friends, enemies, isVisible)
	local box
	initRangeTiles(self.rangeTilesMove, friends)
	local i, j
	for i = 1, 8 do
		for j = 1, 8 do
			if isSomeUnitAt({x = i-1, y = j-1}, enemies) then
				self.rangeTilesMove[i][j].isOccupied = true
			end
		end
	end
	self.rangeTilesMove[selectedUnit.pos.x+1][selectedUnit.pos.y+1].isOccupied = false
	activateTile(selectedUnit.pos, self.rangeTilesMove, selectedUnit.stats.live.moves+1)
	self.rangeTilesMove[selectedUnit.pos.x+1][selectedUnit.pos.y+1].withinRange = false
	for i = 1, 8 do
		for j = 1, 8 do
			if self.rangeTilesMove[i][j].withinRange then
				box = display.newRect(offsetX + 32*(i-1), offsetY + 32*(j-1), 32, 32)
				box:setFillColor(255, 255, 0)
				box.alpha = 0.5
				if not isVisible then
					box.alpha = 0
				end
				self.rangeTileMoveGroup:insert(box)
			end
		end
	end
end

function Board:drawAttackRange(selectedUnit, enemies, isVisible)
	local atkRange
	if selectedUnit.atkModeIsMelee then
		atkRange = selectedUnit.stats.live.melee.rng
	else
		atkRange = selectedUnit.stats.live.ranged.rng
	end
	local box
	initRangeTiles(self.rangeTilesAttack, enemies)
	local i, j
	for i = 1, 8 do
		for j = 1, 8 do
			if self.rangeTilesAttack[i][j].isOccupied then
				if (selectedUnit:distanceTo({x = i-1, y = j-1}, enemies) <= atkRange) then
					self.rangeTilesAttack[i][j].withinRange = true
				end
			end
		end
	end
	for i = 1, 8 do
		for j = 1, 8 do
			if self.rangeTilesAttack[i][j].withinRange then
				box = display.newRect(offsetX + 32*(i-1), offsetY + 32*(j-1), 32, 32)
				box:setFillColor(255, 0, 0)
				box.alpha = 0.5
				if not isVisible then
					box.alpha = 0
				end
				self.rangeTileAttackGroup:insert(box)
			end
		end
	end
end

function Board:destroyRangeVision()
	display.remove(self.rangeTileMoveGroup)
	display.remove(self.rangeTileAttackGroup)
	self.rangeTileMoveGroup = display.newGroup()
	self.rangeTileAttackGroup = display.newGroup()
	self.rangeTileGroup:insert(self.rangeTileMoveGroup)
	self.rangeTileGroup:insert(self.rangeTileAttackGroup)
	self.rangeTilesMove = {}
	self.rangeTilesAttack = {}
end

function Board:isItWithinMoveRange(loc)
	return self.rangeTilesMove[loc.x+1][loc.y+1].withinRange
end

function Board:isItWithinAttackRange(loc)
	return self.rangeTilesAttack[loc.x+1][loc.y+1].withinRange
end

isSomeUnitAt = function (loc, units)
	local occupied = false
	for i in pairs(units) do
		if (units[i]:distanceTo(loc) == 0) then
			occupied = true
		end
	end
	return occupied
end

initRangeTiles = function (rangeTiles, units)
	local i, j
	for i = 1, 8 do
		rangeTiles[i] = {}
		for j = 1, 8 do
			rangeTiles[i][j] = {}
			if isSomeUnitAt({x = i-1, y = j-1}, units) then
				rangeTiles[i][j].isOccupied = true
			end
			rangeTiles[i][j].withinRange = false
		end
	end
end

activateTile = function (position, rangeTiles, numMovesLeft)
	if not rangeTiles[position.x+1][position.y+1].isOccupied and (numMovesLeft > 0) then
		rangeTiles[position.x+1][position.y+1].withinRange = true
		if (position.x > 0) then
			activateTile({x = position.x - 1, y = position.y}, rangeTiles, numMovesLeft - 1)
		end
		if (position.x < 7) then
			activateTile({x = position.x + 1, y = position.y}, rangeTiles, numMovesLeft - 1)
		end
		if (position.y > 0) then
			activateTile({x = position.x, y = position.y - 1}, rangeTiles, numMovesLeft - 1)
		end
		if (position.y < 7) then
			activateTile({x = position.x, y = position.y + 1}, rangeTiles, numMovesLeft - 1)
		end
	end
end

return Board