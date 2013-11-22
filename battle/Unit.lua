local UnitGraphics = require("UnitGraphics")
local UnitBaseStats = require("UnitBaseStats")

local Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local newUnit = {}
	
	local properties = UnitGraphics.getProperties(params.unitType)
	local imageSheet = graphics.newImageSheet(properties.fileName, properties.sheetData)
	
	newUnit.stats = {}
	local base = UnitBaseStats.getBaseStats(params.unitType)
	newUnit.stats.base = base
	newUnit.stats.live = {
		melee = {atk = base.melee.atk, def = base.melee.def},
		ranged = {atk = base.ranged.atk, def = base.ranged.def},
		health = base.health,
		moves = base.moves
	}
	newUnit.pos = {x = params.pos.x, y = params.pos.y}
	newUnit.atkMelee = newUnit.stats.base.melee.atk >= newUnit.stats.base.ranged.atk
	newUnit.anim = display.newSprite(imageSheet, properties.sequenceData)
	newUnit.anim:setReferencePoint(display.TopLeftReferencePoint)
	newUnit.anim.x = (params.pos.x * 32) + 32
	newUnit.anim.y = (params.pos.y * 32) + 60
	newUnit.anim:play()
	newUnit.group = display.newGroup()
	
	setmetatable(newUnit, Unit)
	return newUnit
end

function Unit:tryMove(touch, enemies, friends)
	local enoughMoves = (self:distanceTo(touch) <= self.stats.live.moves)
	local isEnemyHere, isFriendHere = false, false
	
	for i in pairs(enemies) do
		isEnemyHere = isEnemyHere or enemies[i]:isAt(touch)
	end
	for i in pairs(friends) do
		isFriendHere = isFriendHere or friends[i]:isAt(touch)
	end

	-- change direction of unit to match desired move
	if self.pos.x > touch.x then
		self.anim:setSequence("idle_left")
	elseif self.pos.x  < touch.x then
		self.anim:setSequence("idle_right")
	end
	self.anim:play()
	
	if isEnemyHere then
		print ("An enemy is on that square.")
	elseif isFriendHere then
		print ("A friendly unit is on that square.")
	elseif not enoughMoves then
		print ("Too far away!")
	else
		self.stats.live.moves = self.stats.live.moves - self:distanceTo(touch)
		self.pos.x = touch.x
		self.pos.y = touch.y
		self.anim.x = (touch.x * 32) + 32
		self.anim.y = (touch.y * 32) + 60
	end
	
	if self.stats.live.moves == 0 then
		self:resetMoves()
	end
end

function Unit:resetMoves()
	self.stats.live.moves = self.stats.base.moves
end

function Unit:switchAtk()
	if self.atkMelee == true and (self.stats.live.ranged.atk> 0) then
		self.atkMelee = false
	else
		self.atkMelee = true
	end
end

function Unit:distanceTo(loc)
	local distance = math.abs(self.pos.x - loc.x) + math.abs(self.pos.y - loc.y)
	print (distance)
	return distance
end

function Unit:isAt(loc)
	return (self:distanceTo(loc) == 0)
end

return Unit