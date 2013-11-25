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
		melee = {atk = base.melee.atk, def = base.melee.def, rng = base.melee.rng},
		ranged = {atk = base.ranged.atk, def = base.ranged.def, rng = base.ranged.rng},
		health = base.health,
		moves = base.moves
	}
	
	newUnit.pos = {x = params.pos.x, y = params.pos.y}
	newUnit.atkModeIsMelee = newUnit.stats.base.melee.atk >= newUnit.stats.base.ranged.atk
	newUnit.movModeIsMove = false
	newUnit.defending = false
	newUnit.toDie = false
	
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
	
	self:directFace(touch)
	
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
	if self.atkModeIsMelee and (self.stats.live.ranged.atk > 0) then
		self.atkModeIsMelee = false
	else
		self.atkModeIsMelee = true
	end
end

function Unit:tryAttack(touch, enemies)
	local enoughMoves = (self:distanceTo(touch) <= self.stats.live.moves)
	local tooFar = false
	local opposingUnit
	
	if self.atkModeIsMelee then
		tooFar = (self:distanceTo(touch) > self.stats.live.melee.rng)
	else
		tooFar = (self:distanceTo(touch) > self.stats.live.ranged.rng)
	end
	
	for i in pairs(enemies) do
		if enemies[i]:isAt(touch) then
			opposingUnit = enemies[i]
		end
	end

	self:directFace(touch)
	
	if opposingUnit == nil then
		print ("There is no enemy on that square.")
	elseif tooFar then
		print ("The enemy is too far away!")
	else
		self.stats.live.moves = self.stats.live.moves - 1
		if self.atkModeIsMelee then
			opposingUnit:takeDamage(self.atkModeIsMelee, self.stats.live.melee.atk)
		else
			opposingUnit:takeDamage(self.atkModeIsMelee, self.stats.live.ranged.atk)
		end
		if opposingUnit.toDie and self.atkModeIsMelee then
			self.pos.x = opposingUnit.pos.x
			self.pos.y = opposingUnit.pos.y
			self.anim.x = (opposingUnit.anim.x * 32) + 32
			self.anim.y = (opposingUnit.anim.y * 32) + 60
		end
	end
	
	if self.stats.live.moves == 0 then
		self:resetMoves()
	end
end

function Unit:takeDamage(isMelee, attackPower)
	local defensePower
	if isMelee then
		defensePower = self.stats.live.melee.def
	else
		defensePower = self.stats.live.ranged.def
	end
	if self.defending then
		defensePower = math.floor(defensePower * 1.5)
	end
	self.stats.live.health = self.stats.live.health - (attackPower - defensePower)
	if (self.stats.live.health <= 0) then
		self:die()
	end
end

function Unit:die()
	self.anim:removeSelf()
	self.toDie = true
end

function Unit:distanceTo(loc)
	return math.abs(self.pos.x - loc.x) + math.abs(self.pos.y - loc.y)
end

function Unit:directFace(touch)
	if self.pos.x > touch.x then
		self.anim:setSequence("idle_left")
	elseif self.pos.x  < touch.x then
		self.anim:setSequence("idle_right")
	end
	self.anim:play()
end

function Unit:isAt(loc)
	return (self:distanceTo(loc) == 0)
end

return Unit