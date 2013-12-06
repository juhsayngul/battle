local storyboard = require( "storyboard" )
local Board = require( "Board" )
local Unit = require ("Unit")
local Menu = require ("Menu")
local StatsOverlay = require ("StatsOverlay")
local GUI = require ("GUI")
local sfx = require("sfx")

local scene = storyboard.newScene()

local cancelled = false
local inspecting = false
local gamePaused = false
local gameOver = false
local waitForAni = false

local inspectingText

local buttonListener = {}
local menu = nil
local stats = nil
local enemystats = nil
local isOrangeTurn = true

local gui, board
local friends, enemies
local selectedUnit, inspectedUnit

local getUnits, getGroup, onEveryFrame, handleTouch, createMenu, destroyMenu

local unitChoice, unitVictim
local uselessUnits = {}
local boardForAI

function scene:createScene(event)
    local screenGroup = self.view
	
	local params = event.params
	local friendsGroup, enemiesGroup
	
	levelGroup = display.newGroup()
	
	board = Board.new({visible = true})
	boardForAI = Board.new({visible = false})
	gui = GUI.new(buttonListener, isOrangeTurn, false)
	
	
	inspectingText = display.newText(" ", 0, 0, native.systemFontBold, 12)
	inspectingText.x, inspectingText.y = 160, 442
	
	friends = getUnits(params.friendParams)
	enemies = getUnits(params.enemyParams)
	friendsGroup = getGroup(friends)
	enemiesGroup = getGroup(enemies)
	
	levelGroup:insert(friendsGroup)
	levelGroup:insert(enemiesGroup)
	levelGroup:insert(board.rangeTileGroup)
	levelGroup:insert(board.group)
	levelGroup:insert(gui.group)
	
	board.rangeTileGroup:toBack()
	gui.group:toBack()
	friendsGroup:toBack()
	enemiesGroup:toBack()
	board.group:toBack()
	
	screenGroup:insert(levelGroup)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	audio.stop(sfx.channels.bgm)
	sfx.channels.bgm = audio.play(sfx.bgm, {loops=-1})
	
	Runtime:addEventListener("enterFrame", onEveryFrame)
	Runtime:addEventListener("touch", handleTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	audio.stop(sfx.channels.bgm)
	sfx.channels.bgm = audio.play(sfx.menu, {loops=-1})
	
	local i
	for i in pairs(friends) do
		friends[i]:resetDefending()
		friends[i]:stopBeingInspected()
	end
	for i in pairs(enemies) do
		enemies[i]:resetDefending()
		enemies[i]:stopBeingInspected()
	end
	
	destroyMenu()
	gui:destroy(buttonListener)
	
	Runtime:removeEventListener("enterFrame", onEveryFrame)
    Runtime:removeEventListener("touch", handleTouch)
end

function scene:overlayBegan( event )
	if gamePaused then
		local i
		for i in pairs(friends) do
			friends[i].anim:pause()
		end
		for i in pairs(enemies) do
			enemies[i].anim:pause()
		end
		audio.setVolume(sfx.volume.QUIET)
	end
end

function scene:overlayEnded( event )
	if gamePaused then
		local i
		gamePaused = false
		for i in pairs(friends) do
			friends[i].anim:play()
		end
		for i in pairs(enemies) do
			enemies[i].anim:play()
		end
		audio.setVolume(sfx.volume.LOUD)
	end
end

local function startInspecting()
	inspecting = true
	inspectingText.text = "Select a unit to inspect."
end

local function quitInspecting()
	inspecting = false
	inspectingText.text = " "
	if inspectedUnit ~= nil then
		inspectedUnit:stopBeingInspected()
	end
end

createMenu = function(touchedUnit)
	selectedUnit = touchedUnit
	selectedUnit.defending = false
	menu = Menu.new(buttonListener, selectedUnit)
	stats = StatsOverlay.new(selectedUnit)
	if enemystats ~= nil and inspectedUnit ~= nil then
		enemystats:destroy()
		if selectedUnit == nil then
			enemystats = StatsOverlay:enemyStats(inspectedUnit, inspectedUnit.atkModeIsMelee)
		else
			enemystats = StatsOverlay:enemyStats(inspectedUnit, selectedUnit.atkModeIsMelee)
		end
		inspectedUnit:beInspected()
		scene.view:insert(enemystats.group)
	end
	scene.view:insert(menu.group)
	scene.view:insert(stats.group)
end

local function refreshRangeDisplay()
	board:destroyRangeVision()
	
	local opposition, teammates
	
	opposition = enemies
	teammates = friends
	
	if not isOrangeTurn then
		opposition = friends
		teammates = enemies
	end
	
	if not (selectedUnit == nil) and (not (menu == nil)) then
		if selectedUnit.movModeIsMove then
			board:drawMoveRange(selectedUnit, teammates, opposition, true)
		else
			board:drawAttackRange(selectedUnit, opposition, true)
		end
	end
end

destroyMenu = function ()
	if menu ~= nil then
		menu:destroy(buttonListener)
	end
	if stats ~= nil then
		stats:destroy()
	end
	stats = nil
	selectedUnit = nil
	menu = nil
end

local function win()
	local options = {
		effect = "fromBottom",
		time = 300,
		params = {destination = "Title-Screen"},
		isModal = true
	}
	storyboard.showOverlay("Win-Overlay", options)
end

local function lose()
	local options = {
		effect = "fromBottom",
		time = 300,
		params = {destination = "Title-Screen"},
		isModal = true
	}
	storyboard.showOverlay("Lose-Overlay", options)
end

local function checkIfEnded()
	if #enemies < 1 then
		win()
		gameOver = true
	elseif #friends < 1 then
		lose()
		gameOver = true
	end
end

buttonListener.switchMov = function (event)
	if event.phase == "began" then
		selectedUnit:switchMov()
		menu:switchMov(buttonListener, selectedUnit.movModeIsMove)
		refreshRangeDisplay()
	end
end

buttonListener.switchAtk = function (event)
	if event.phase == "began" then
		if selectedUnit.atkModeIsMelee and (selectedUnit.stats.live.ranged.atk > 0) or
		selectedUnit.atkModeIsMelee ~= true and (selectedUnit.stats.live.melee.atk > 0) then
			menu:switchAtk(buttonListener, selectedUnit.atkModeIsMelee, selectedUnit)
			stats:update(selectedUnit)
		end
		selectedUnit:switchAtk()
		refreshRangeDisplay()
		if enemystats ~= nil then
			enemystats:destroy()
		end
		if inspectedUnit ~= nil then
			if selectedUnit == nil then
				enemystats = StatsOverlay:enemyStats(inspectedUnit, inspectedUnit.atkModeIsMelee)
			else
				enemystats = StatsOverlay:enemyStats(inspectedUnit, selectedUnit.atkModeIsMelee)
			end
			scene.view:insert(enemystats.group)
		end
	end
end

buttonListener.defend = function (event)
	if event.phase == "began" then
		audio.play(sfx.click)
		selectedUnit:defend()
	end
end

buttonListener.cancel = function (event)
	if event.phase == "began" then
		audio.play(sfx.click)
		cancelled = true
		if selectedUnit.stats.live.moves ~= selectedUnit.stats.base.moves then
			if not inspecting then
				startInspecting()
			else
				quitInspecting()
			end
		else
			cancelled = true
		end
	end
end

buttonListener.pause = function (event)
	if event.phase == "began" and not gamePaused then
		audio.play(sfx.click)
		gamePaused = true
		local options = {
			effect = "fromBottom",
			time = 100,
			params = {destination = "Title-Screen"},
			isModal = true
		}
		storyboard.showOverlay("Pause-Overlay", options)
	end
end

getUnits = function (params)
	local i
	local units = {}
	
	for i in pairs (params) do
		units[i] = Unit.new(params[i])
	end
	
	return units
end

getGroup = function (units)
	local i
	local group = display.newGroup()
	
	for i in pairs (units) do
		group:insert(units[i].anim)
	end
	
	return group
end

onEveryFrame = function(event)
	if enemystats == nil then
		if inspectedUnit ~= nil then
			inspectedUnit:stopBeingInspected()
		end
	end
	if (selectedUnit ~= nil) then
		if (selectedUnit.stats.live.moves == 0) then
			cancelled = true
			local i
			if isOrangeTurn then
				gui:switchTurn()
				cancelled = true
				local i
				for i in pairs(enemies) do
					enemies[i]:resetDefending()
					enemies[i]:resetMoves()
					enemies[i]:resetControlModes()
				end
				isOrangeTurn = false
				quitInspecting()
				if enemystats ~= nil then
					enemystats:destroy()
				end
				inspectedUnit = nil
				local stopWaitingForAni = function()
					waitForAni = false
				end
				waitForAni = true
				timer.performWithDelay(1000, stopWaitingForAni)
			-- else
				-- gui:switchTurn()
				-- cancelled = true
				-- local i
				-- for i in pairs(friends) do
					-- friends[i]:resetDefending()
					-- friends[i]:resetMoves()
					-- friends[i]:resetControlModes()
				-- end
				-- isOrangeTurn = true
				-- quitInspecting()
				-- if enemystats ~= nil then
					-- enemystats:destroy()
				-- end
				-- inspectedUnit = nil
			end
		end
	end
	if cancelled then
		cancelled = false
		
		if (selectedUnit ~= nil) then
			if (selectedUnit.stats.base.moves == selectedUnit.stats.live.moves) or (selectedUnit.stats.live.moves == 0) then
				destroyMenu()
				board:destroyRangeVision()
			else
				local unit = selectedUnit
				destroyMenu()
				createMenu(unit)
				refreshRangeDisplay()
			end
		end
	end
	if not isOrangeTurn then
		doAI()
	end
end

handleTouch = function(event)
	local i
	local opposition, teammates
	
	opposition = enemies
	teammates = friends
	
	if not isOrangeTurn then
		opposition = friends
		teammates = enemies
	end
	
	local touch = {
		x = math.floor((event.x - 32) / 32),
		y = math.floor((event.y - 60) / 32),
		hit = false
	}
	
	if event.phase == "began" and isOrangeTurn and not gameOver then
		--if grid is touched
		if (touch.x >= 0 and touch.x < 8) and (touch.y >= 0 and touch.y < 8) then
			if selectedUnit ~= nil then
				if inspecting then
					audio.play(sfx.click)
					quitInspecting()
					for i in pairs(opposition) do
						if opposition[i]:isAt(touch) and not touch.hit then
							if enemystats ~= nil then
								enemystats:destroy()
							end
							if selectedUnit == nil then
								enemystats = StatsOverlay:enemyStats(opposition[i], opposition[i].atkModeIsMelee)
							else
								enemystats = StatsOverlay:enemyStats(opposition[i], selectedUnit.atkModeIsMelee)
							end
							inspectedUnit = opposition[i]
							inspectedUnit:beInspected()
							scene.view:insert(enemystats.group)
							touch.hit = true
						end
					end
					for i in pairs(teammates) do
						if teammates[i]:isAt(touch) and not touch.hit then
							if not (teammates[i].pos.x == selectedUnit.pos.x and teammates[i].pos.y == selectedUnit.pos.y) then
								if enemystats ~= nil then
									enemystats:destroy()
								end
								inspectedUnit = teammates[i]
								inspectedUnit:beInspected()
								if selectedUnit == nil then
									enemystats = StatsOverlay:enemyStats(teammates[i], teammates[i].atkModeIsMelee)
								else
									enemystats = StatsOverlay:enemyStats(teammates[i], selectedUnit.atkModeIsMelee)
								end
								scene.view:insert(enemystats.group)
								touch.hit = true
							end
						end
					end
				else
					if selectedUnit.movModeIsMove then
						selectedUnit:tryMove(touch, board:isItWithinMoveRange({x = touch.x, y = touch.y}), board:getNumMovesTo({x = touch.x, y = touch.y}))
					elseif not (selectedUnit.movModeIsMove or (menu == nil)) then
						selectedUnit:tryAttack(touch, opposition, board:isItWithinAttackRange({x = touch.x, y = touch.y}))
					end
				end
			elseif menu == nil then
				--check friendly units for touch
				for i in pairs(teammates) do
					if teammates[i]:isAt(touch) and not touch.hit then
						createMenu(teammates[i])
						audio.play(sfx.click)
						touch.hit = true
					end
				end
				
				--check enemy units for touch
				for i in pairs(opposition) do
					if opposition[i]:isAt(touch) and not touch.hit then
						if stats ~= nil then
							stats:destroy()
						end
						if enemystats ~= nil then
							enemystats:destroy()
						end
						if inspectedUnit ~= nil then
							inspectedUnit:stopBeingInspected()
						end
						audio.play(sfx.click)
						inspectedUnit = opposition[i]
						if selectedUnit == nil then
							enemystats = StatsOverlay:enemyStats(inspectedUnit, inspectedUnit.atkModeIsMelee)
						else
							enemystats = StatsOverlay:enemyStats(inspectedUnit, selectedUnit.atkModeIsMelee)
						end
						inspectedUnit:beInspected()
						scene.view:insert(enemystats.group)
						touch.hit = true
					end
				end
			end
			
			if not touch.hit then
				audio.play(sfx.click)
				cancelled = true
				if enemystats ~= nil then
					enemystats:destroy()
				end
				if inspectedUnit ~= nil then
					inspectedUnit:stopBeingInspected()
					inspectedUnit = nil
				end
			end
			
			for i in pairs(opposition) do
				if opposition[i].toDie then
					table.remove(opposition, i)
				end
			end
			for i in pairs(teammates) do
				if teammates[i].toDie then
					table.remove(teammates, i)
				end
			end
			
			refreshRangeDisplay()
			
			checkIfEnded()
		end
	end
end

local function pickBestUnit(units)
	local unitChoices = {}
	local i
	local maximum = 0
	for i in pairs(units) do
		if (units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health > maximum) then
			maximum = units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health
			unitChoices = {}
			table.insert(unitChoices, units[i])
		elseif (units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health == maximum) then
			table.insert(unitChoices, units[i])
		end
		if (units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health > maximum) then
			maximum = units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health
			unitChoices = {}
			table.insert(unitChoices, units[i])
		elseif (units[i].stats.live.melee.atk*3 + units[i].stats.live.moves*2 + units[i].stats.live.health == maximum) then
			table.insert(unitChoices, units[i])
		end
	end
	
	return unitChoices[math.floor((math.random() * #unitChoices))+1]
end

local function pickClosestWeakestOpposingUnit(melee, loc, units)
	local weakUnits = {}
	local i
	local minimum = 5
	for i in pairs(units) do
		if melee then
			if (units[i].stats.live.melee.def < minimum) then
				minimum = units[i].stats.live.melee.def
				weakUnits = {}
				table.insert(weakUnits, units[i])
			elseif (units[i].stats.live.melee.def == minimum) then
				table.insert(weakUnits, units[i])
			end
		else
			if (units[i].stats.live.ranged.def < minimum) then
				minimum = units[i].stats.live.ranged.def
				weakUnits = {}
				table.insert(weakUnits, units[i])
			elseif (units[i].stats.live.ranged.def == minimum) then
				table.insert(weakUnits, units[i])
			end
		end
	end
	
	minimum = 15
	local closeWeakUnits = {}
	for i in pairs(weakUnits) do
		if (weakUnits[i]:distanceTo(loc) < minimum) then
			minimum = weakUnits[i]:distanceTo(loc)
			closeWeakUnits = {}
			table.insert(closeWeakUnits, weakUnits[i])
		elseif (weakUnits[i]:distanceTo(loc) == minimum) then
			table.insert(closeWeakUnits, weakUnits[i])
		end
	end
	
	return closeWeakUnits[math.floor((math.random() * #closeWeakUnits))+1]
end

local function pickClosestLocationToUnit(locations, unit)
	local closeLocations = {}
	local minimum = 15
	local i
	for i in pairs(locations) do
		if (unit:distanceTo(locations[i]) < minimum) then
			minimum = unit:distanceTo(locations[i])
			closeLocations = {}
			table.insert(closeLocations, locations[i])
		elseif (unit:distanceTo(locations[i]) == minimum) then
			table.insert(closeLocations, locations[i])
		end
	end
	return closeLocations[math.floor((math.random() * #closeLocations))+1]
end

doAI = function()
	local opposition, teammates = friends, enemies
	local stopWaitingForAni = function()
		waitForAni = false
	end
	
	local doWait = true
	local movesNow
	local death = false
	
	if not gamePaused and not waitForAni and (#teammates > 0) and not gameOver then
		if unitChoice == nil then
			unitChoice = pickBestUnit(enemies)
		end
		if unitVictim == nil then
			unitVictim = pickClosestWeakestOpposingUnit(unitChoice.atkModeIsMelee, unitChoice.pos, opposition)
		end
		movesNow = unitChoice.stats.live.moves
		if (movesNow > 0) and (#opposition > 0) then
			boardForAI:drawAttackRange(unitChoice, opposition, false)
			
			if boardForAI:isItWithinAttackRange(unitVictim.pos) then
				unitChoice:tryAttack(unitVictim.pos, opposition, boardForAI:isItWithinAttackRange(unitVictim.pos))
			end
			
			local i
			for i in pairs(opposition) do
				if opposition[i].toDie then
					table.remove(opposition, i)
					death = true
				end
			end
			for i in pairs(teammates) do
				if teammates[i].toDie then
					table.remove(teammates, i)
					death = true
				end
			end
			
			boardForAI:drawMoveRange(unitChoice, teammates, opposition, false)
			
			local locations = boardForAI:getAvailableMoveLocations()
			local closest = pickClosestLocationToUnit(locations, unitVictim)
			
			if not death and closest ~= nil then
				if (movesNow == unitChoice.stats.live.moves) then
					unitChoice:tryMove(closest, boardForAI:isItWithinMoveRange(closest), boardForAI:getNumMovesTo(closest))
				end
			end
			
			if (movesNow == unitChoice.stats.live.moves) then
				table.insert(uselessUnits, unitChoice)
				local i, j
				for i in pairs(uselessUnits) do
					for j in pairs(teammates) do
						if (teammates[j]:distanceTo(uselessUnits[i].pos) == 0) then
							table.remove(teammates, j)
						end
					end
				end
				unitChoice = pickBestUnit(teammates)
				for i in pairs(uselessUnits) do
					table.insert(teammates, uselessUnits[i])
				end
				doWait = false
			end
			
			boardForAI:destroyRangeVision()
		end
		
		if (unitChoice.stats.live.moves == 0) then
			gui:switchTurn()
			cancelled = true
			local i
			for i in pairs(friends) do
				friends[i]:resetDefending()
				friends[i]:resetMoves()
				friends[i]:resetControlModes()
			end
			isOrangeTurn = true
			unitChoice = nil
			unitVictim = nil
			uselessUnits = {}
		end
		
		if doWait then
			waitForAni = true
			timer.performWithDelay(1000, stopWaitingForAni)
		end
		checkIfEnded()
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("overlayBegan")
scene:addEventListener("overlayEnded")

return scene