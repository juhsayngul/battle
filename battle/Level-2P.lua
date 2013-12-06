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

local getUnits, getGroup, onEveryFrame, handleTouch, destroyMenu
local stopWaitingForAni

function scene:createScene(event)
    local screenGroup = self.view
	
	local params = event.params
	local friendsGroup, enemiesGroup
	
	levelGroup = display.newGroup()
	
	board = Board.new(params.boardParams)
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

local function createMenu(touchedUnit)
	selectedUnit = touchedUnit
	selectedUnit.defending = false
	menu = Menu.new(buttonListener, selectedUnit)
	stats = StatsOverlay.new(selectedUnit)
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
		params = {destination = "Two-Player"},
		isModal = true
	}
	storyboard.showOverlay("Win-Overlay", options)
end

local function lose()
	win()
end

local function checkIfEnded()
	if #enemies < 1 then
		win()
	elseif #friends < 1 then
		lose()
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
			params = {destination = "Two-Player"},
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
	if (selectedUnit ~= nil) then
		if (selectedUnit.stats.live.moves == 0) then
			cancelled = true
			local i
			if isOrangeTurn then
				for i in pairs(enemies) do
					enemies[i]:resetDefending()
					enemies[i]:resetMoves()
					enemies[i]:resetControlModes()
				end
				isOrangeTurn = false
			else
				for i in pairs(friends) do
					friends[i]:resetDefending()
					friends[i]:resetMoves()
					friends[i]:resetControlModes()
				end
				isOrangeTurn = true
			end
			quitInspecting()
			if enemystats ~= nil then
				enemystats:destroy()
			end
			gui:switchTurn()
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
	
	if event.phase == "began" then
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
							enemystats = StatsOverlay:enemyStats(opposition[i])
							inspectedUnit = opposition[i]
							inspectedUnit:beInspected()
							scene.view:insert(enemystats.group)
							touch.hit = true
						end
						if teammates[i]:isAt(touch) and not touch.hit then
							if not (teammates[i].pos.x == selectedUnit.pos.x and teammates[i].pos.y == selectedUnit.pos.y) then
								if enemystats ~= nil then
									enemystats:destroy()
								end
								inspectedUnit = teammates[i]
								inspectedUnit:beInspected()
								enemystats = StatsOverlay:enemyStats(teammates[i])
								scene.view:insert(enemystats.group)
								touch.hit = true
							end
						end
					end
				else
					if selectedUnit.movModeIsMove then
						selectedUnit:tryMove(touch, board:isItWithinMoveRange({x = touch.x, y = touch.y}))
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
						enemystats = StatsOverlay:enemyStats(opposition[i])
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

doAI = function()
	if not waitForAni then
		
	end
end

stopWaitingForAni = function()
	local waitForAni = false
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("overlayBegan")
scene:addEventListener("overlayEnded")

return scene