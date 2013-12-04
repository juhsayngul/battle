local UnitGraphics = require("UnitGraphics")
local UnitBaseStats = require("UnitBaseStats")

local Unit = {}
Unit.__index = Unit

local showDeathAnimation, flashDamageAmount, flashAttackIndicator

function Unit.new(params)
	local newUnit = {}
	newUnit.group = display.newGroup()
	
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
	newUnit.movModeIsMove = true
	newUnit.defending = false
	newUnit.toDie = false
	
	newUnit.anim = display.newSprite(imageSheet, properties.sequenceData)
	newUnit.anim:setReferencePoint(display.TopLeftReferencePoint)
	newUnit.anim.x = (params.pos.x * 32) + 32
	newUnit.anim.y = (params.pos.y * 32) + 60
	newUnit.anim:play()
	newUnit.group:insert(newUnit.anim)
	
	setmetatable(newUnit, Unit)
	return newUnit
end

function Unit:resetMoves()
	self.stats.live.moves = self.stats.base.moves
end

function Unit:resetControlModes()
	self.atkModeIsMelee = self.stats.live.melee.atk >= self.stats.live.ranged.atk
	self.movModeIsMove = true
end

function Unit:switchAtk()
	if self.atkModeIsMelee and (self.stats.live.ranged.atk > 0) then
		self.atkModeIsMelee = false
	else
		self.atkModeIsMelee = true
	end
end

function Unit:switchMov()
	if self.movModeIsMove then
		self.movModeIsMove = false
	else
		self.movModeIsMove = true
	end
end

function Unit:tryMove(touch, isInRange)
	self:directFace(touch)
	
	if isInRange then
		self.stats.live.moves = self.stats.live.moves - self:distanceTo(touch)
		self.pos.x = touch.x
		self.pos.y = touch.y
		self.anim.x = (touch.x * 32) + 32
		self.anim.y = (touch.y * 32) + 60
	end
end

function Unit:tryAttack(touch, enemies, isInRange)
	local opposingUnit
	
	for i in pairs(enemies) do
		if enemies[i]:isAt(touch) then
			opposingUnit = enemies[i]
		end
	end

	self:directFace(touch)
	
	if (not (opposingUnit == nil)) and isInRange then
		self.stats.live.moves = self.stats.live.moves - 1
		if self.atkModeIsMelee then
			opposingUnit:takeDamage(self.atkModeIsMelee, self.stats.live.melee.atk)
		else
			opposingUnit:takeDamage(self.atkModeIsMelee, self.stats.live.ranged.atk)
		end
	end
end

function Unit:takeDamage(isMelee, attackPower)
	local defensePower
	local damageAmount
	if isMelee then
		defensePower = self.stats.live.melee.def
	else
		defensePower = self.stats.live.ranged.def
	end
	if self.defending then
		defensePower = math.floor(defensePower * 1.5)
	end
	damageAmount = attackPower - defensePower
	self.stats.live.health = self.stats.live.health - damageAmount
	flashDamageAmount(self, damageAmount)
	if (self.stats.live.health <= 0) then
		self:die()
	else
		flashAttackIndicator(self)
	end
end

function Unit:die()
	self:resetDefending()
	self.anim:removeSelf()
	self.toDie = true
	showDeathAnimation(self)
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

function Unit:resetDefending()
	if self.defendImage ~= nil then
		display.remove(self.defendImage)
	end
	self.defendImage = nil
	self.defending = false
end

function Unit:defend()
	if self.defendImage == nil then
		self.defendImage = display.newImage("assets/defend_symbol.png", self.anim.x, self.anim.y)
		self.group:insert(self.defendImage)
		self.defendImage:toFront()
	end
	self.defending = true
	self.stats.live.moves = 0
end

showDeathAnimation = function(dyingUnit)
	aniWidth = 5 -- these variables are dummies, they should really be the dimensions of the animation graphic
	aniHeight = 5
	local animationLocX = (dyingUnit.pos.x * 32) + 32
	local animationLocY = (dyingUnit.pos.y * 32) + 60
	-- create a graphic whose animation ends with a few frames of nothing so that we can calibrate the wait time
	local graphic = display.newRect(animationLocX, animationLocY, 32, 32)
	graphic.strokeWidth = 2
	graphic:setFillColor(0, 0, 0, 1)
	graphic:setStrokeColor(255, 0, 0)
	-- animation ideas... poof! they're gone
	-- graphic location should be at animationLocX/animationLocY variables above
	-- 		which should be a random spot over the target unit
	dyingUnit.group:insert(graphic)
	graphic:toFront()
	local function destroy ()
		display.remove(graphic)
	end
	timer.performWithDelay(500, destroy) -- rough delay time amount, should actually reflect full amount of animation
end

flashDamageAmount = function(targetedUnit, damageAmount)
	local animationLocX = (targetedUnit.pos.x * 32) + math.floor(math.random() * (32 - 20)) + 32
	local animationLocY = (targetedUnit.pos.y * 32) + math.floor(math.random() * (36 - 20)) + 60 - 16 
	local text = display.newText("-" .. damageAmount, animationLocX, animationLocY, native.systemFontBold, 16)
	-- rough positioning and text parameters but it works and looks neat enough
	text:setTextColor(255, 255, 255)
	targetedUnit.group:insert(text)
	text:toFront()
	local maxCountdown = 24
	local countdown = maxCountdown
	local function onEveryFrame()
		if (countdown == 0) then
			display.remove(text)
			Runtime:removeEventListener("enterFrame", onEveryFrame)
		else
			if ((text.alpha - 1/maxCountdown) > 0) then
				text.alpha = text.alpha - 1/maxCountdown
			end
			text.y = text.y - 1
		end
		countdown = countdown - 1
	end
	Runtime:addEventListener("enterFrame", onEveryFrame)
end

flashAttackIndicator = function(targetedUnit)
	aniWidth = 5 -- these variables are dummies, they should really be the dimensions of the animation graphic
	aniHeight = 5
	local animationLocX = (targetedUnit.pos.x * 32) + math.floor(math.random() * (32 - aniWidth)) + 32
	local animationLocY = (targetedUnit.pos.y * 32) + math.floor(math.random() * (36 - aniHeight)) + 60
	-- create a graphic whose animation ends with a few frames of nothing so that we can calibrate the wait time
	local graphic = display.newRect(animationLocX, animationLocY, 5, 5)
	graphic.strokeWidth = 2
	graphic:setFillColor(0, 0, 0, 1)
	graphic:setStrokeColor(255, 0, 0)
	-- the graphic should look like some sort of criss-cross spark
	-- graphic location should be at animationLocX/animationLocY variables above
	-- 		which should be a random spot over the target unit
	targetedUnit.group:insert(graphic)
	graphic:toFront()
	local function destroy ()
		display.remove(graphic)
	end
	timer.performWithDelay(500, destroy) -- rough delay time amount, should actually reflect full amount of animation
end

return Unit