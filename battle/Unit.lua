local UnitGraphics = require("UnitGraphics")
local UnitBaseStats = require("UnitBaseStats")
local sfx = require("sfx")

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
	
	newUnit.unitType = params.unitType
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

function Unit:tryMove(touch, isInRange, numMovesTo)
	self:directFace(touch)
	
	if isInRange then
		self.stats.live.moves = self.stats.live.moves - numMovesTo
		self.pos.x = touch.x
		self.pos.y = touch.y
		self.anim.x = (touch.x * 32) + 32
		self.anim.y = (touch.y * 32) + 60
		
		sfx.playMoveSound(self.unitType)
	else
		audio.play(sfx.badMove)
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
		sfx.playAttSound(self.unitType)
	else
		audio.play(sfx.badMove)
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
	if damageAmount < 0 then
		damageAmounut = 0
	end
	self.stats.live.health = self.stats.live.health - damageAmount
	flashDamageAmount(self, damageAmount)
	if (self.stats.live.health <= 0) then
		self:die()
	end
	flashAttackIndicator(self, isMelee)
end

function Unit:die()
	sfx.playDeathSound(self.unitType)
	self:resetDefending()
	self:stopBeingInspected()
	display.remove(self.anim)
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

function Unit:beInspected()
	if self.inspectImage == nil then
		self.inspectImage = display.newImage("assets/inspect_symbol.png", self.anim.x, self.anim.y)
		self.group:insert(self.inspectImage)
		self.inspectImage:toFront()
	end
end

function Unit:stopBeingInspected()
	if self.inspectImage ~= nil then
		display.remove(self.inspectImage)
	end
	self.inspectImage = nil
end

showDeathAnimation = function(dyingUnit)
	local animationLocX = (dyingUnit.pos.x * 32) + 32
	local animationLocY = (dyingUnit.pos.y * 32) + 60
	
	local graphic = display.newRect(animationLocX, animationLocY, 32, 32)
	graphic.strokeWidth = 2
	graphic:setFillColor(0, 0, 0, 1)
	graphic:setStrokeColor(255, 0, 0)
	
	dyingUnit.group:insert(graphic)
	graphic:toFront()
	if dyingUnit.unitType == "tank_e" or dyingUnit.unitType == "tank_f" or dyingUnit.unitType == "cannon_e" or dyingUnit.unitType == "cannon_f" 
	or dyingUnit.unitType == "heli_e" or dyingUnit.unitType == "heli_f" then
		local sheetdata = {width = 32, height = 32, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 32}
		local options = 
		{
			name = "explosion",
			frames = {1, 2, 3, 4, 5, 6},
			time = 250,
			loopCount = 1
		}
		local imageSheet = graphics.newImageSheet("assets/explosion.png", sheetdata)
		local anim = display.newSprite(imageSheet, options)
		anim.x = animationLocX + 16
		anim.y = animationLocY + 16
		anim:play()
		dyingUnit.group:insert(anim)
		anim:toFront()
		local function destroy ()
			display.remove(anim)
		end
		timer.performWithDelay(250, destroy)
	else
		local sheetdata = {width = 32, height = 32, numFrames = 4, sheetContentWidth = 128, sheetContentHeight = 32}
		local options = 
		{
			name = "death",
			frames = {1, 2, 3, 4},
			time = 250,
			loopCount = 1
		}
		local imageSheet = graphics.newImageSheet("assets/death.png", sheetdata)
		local anim = display.newSprite(imageSheet, options)
		anim.x = animationLocX + 16
		anim.y = animationLocY + 16
		anim:play()
		dyingUnit.group:insert(anim)
		anim:toFront()
		local function destroy()
			display.remove(anim)
		end
		timer.performWithDelay(250, destroy)
	end
	local maxCountdown = 16
	local countdown = maxCountdown
	local function onEveryFrame()
		if (countdown == 0) then
			display.remove(graphic)
			Runtime:removeEventListener("enterFrame", onEveryFrame)
		else
			if (graphic.xScale - 1/maxCountdown> 0 and graphic.yScale - 1/maxCountdown > 0) then
				graphic.xScale = graphic.xScale - 1/maxCountdown
				graphic.yScale = graphic.yScale - 1/maxCountdown
			end
		end
		countdown = countdown - 1
	end
	Runtime:addEventListener("enterFrame", onEveryFrame)
end

flashDamageAmount = function(targetedUnit, damageAmount)
	local animationLocX = (targetedUnit.pos.x * 32) + math.floor(math.random()*32) + 32
	local animationLocY = (targetedUnit.pos.y * 32) + math.floor(math.random()*36) + 60 - 16 
	local text = display.newText("-" .. damageAmount, 0, 0, native.systemFontBold, 16)
	text.x = animationLocX
	text.y = animationLocY
	
	text:setTextColor(255, 255, 255)
	targetedUnit.group:insert(text)
	text:toFront()
	local maxCountdown = 32
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

flashAttackIndicator = function(targetedUnit, isMelee)
	local animationLocX = (targetedUnit.pos.x * 32) + math.floor(math.random()*20) + 32 + 6
	local animationLocY = (targetedUnit.pos.y * 32) + math.floor(math.random()*20) + 60 + 6
	
	if isMelee then
		local sheetdata = {width = 16, height = 20, numFrames = 4, sheetContentWidth = 64, sheetContentHeight = 20}
		local options = 
		{
			name = "hit",
			frames = {1, 2, 3, 4},
			time = 160,
			loopCount = 1
		}
		local imageSheet = graphics.newImageSheet("assets/hit.png", sheetdata)
		local anim = display.newSprite(imageSheet, options)
		anim.x = animationLocX
		anim.y = animationLocY
		anim:play()
		targetedUnit.group:insert(anim)
		anim:toFront()
		local function destroy ()
			display.remove(anim)
		end
		timer.performWithDelay(250, destroy)
	else
		local sheetdata = {width = 25, height = 25, numFrames = 4, sheetContentWidth = 100, sheetContentHeight = 25}
		local options = 
		{
			name = "hit",
			frames = {1, 2, 3, 4},
			time = 160,
			loopCount = 1
		}
		local imageSheet = graphics.newImageSheet("assets/hit2.png", sheetdata)
		local anim = display.newSprite(imageSheet, options)
		anim.x = animationLocX
		anim.y = animationLocY
		anim:play()
		targetedUnit.group:insert(anim)
		anim:toFront()
		local function destroy ()
			display.remove(anim)
		end
		timer.performWithDelay(250, destroy)
	end
end

return Unit