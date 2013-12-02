local Board = require( "Board" )
local storyboard = require( "storyboard" )
-- local BG = require( "BG" )
local Unit = require ("Unit")
local Menu = require ("Menu")
local GUI = require ("GUI")

local scene = storyboard.newScene()

local Level = {}
Level.__index = Level

local cancelled = false
local gamePaused = false

local buttonListener = {}
local menu = nil
local isOrangeTurn = true

local friends, enemies
local selectedUnit

local levelParams

local getUnits, getGroup, onEveryFrame, handleTouch

function scene:createScene(event)
    local screenGroup = self.view
	
	local params = event.params
	levelParams = params
	local bg, board, friendsGroup, enemiesGroup, gui
	
	levelGroup = display.newGroup()
	
	board = Board.new(params.boardParams)
	gui = GUI.new(buttonListener)
	-- bg = BG.new(params.bgParams)
	
	friends = getUnits(params.friendParams)
	enemies = getUnits(params.enemyParams)
	friendsGroup = getGroup(friends)
	enemiesGroup = getGroup(enemies)
	
	levelGroup:insert(friendsGroup)
	levelGroup:insert(enemiesGroup)
	levelGroup:insert(board.group)
	levelGroup:insert(gui.group)
	-- levelGroup:insert(bg.group)
	
	gui.group:toBack()
	friendsGroup:toBack()
	enemiesGroup:toBack()
	board.group:toBack()
	-- bg.group:toBack()
	
	screenGroup:insert(levelGroup)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
    -- storyboard.removeScene("Title-Screen")
	
	Runtime:addEventListener("enterFrame", onEveryFrame)
	Runtime:addEventListener("touch", handleTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
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
	end
end

local function createMenu(touchedUnit)
	selectedUnit = touchedUnit
	selectedUnit.defending = false
	menu = Menu.new(buttonListener, selectedUnit)
	scene.view:insert(menu.group)
end

local function destroyMenu()
	if menu ~= nil then
		menu:destroy(buttonListener)
	end
	selectedUnit = nil
	menu = nil
end

local function win()
	local options = {
		effect = "fromBottom",
		time = 300,
		params = levelParams,
		isModal = true
	}
	storyboard.showOverlay("Win-Overlay", options)
end

local function lose()
	local options = {
		effect = "fromBottom",
		time = 300,
		params = levelParams,
		isModal = true
	}
	storyboard.showOverlay("Lose-Overlay", options)
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
	end
end

buttonListener.switchAtk = function (event)
	if event.phase == "began" then
		if selectedUnit.atkModeIsMelee and (selectedUnit.stats.live.ranged.atk > 0) or
		selectedUnit.atkModeIsMelee ~= true and (selectedUnit.stats.live.melee.atk > 0) then
			menu:switchAtk(buttonListener, selectedUnit.atkModeIsMelee)
		end
		selectedUnit:switchAtk()
	end
end

buttonListener.defend = function (event)
	if event.phase == "began" then
		selectedUnit:defend()
	end
end

buttonListener.cancel = function (event)
	if event.phase == "began" then
		print ("Cancelled")
		cancelled = true
	end
end

buttonListener.pause = function (event)
	if event.phase == "began" and not gamePaused then
		gamePaused = true
		local options = {
			effect = "fromBottom",
			time = 300,
			params = levelParams,
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
				isOrangeTurn = false
				for i in pairs(enemies) do
					enemies[i]:resetDefending()
					enemies[i]:resetMoves()
				end
			else
				isOrangeTurn = true
				for i in pairs(friends) do
					friends[i]:resetDefending()
					friends[i]:resetMoves()
				end
			end
		end
	end
	if cancelled then
		cancelled = false
		
		if (selectedUnit ~= nil) then
			if (selectedUnit.stats.base.moves == selectedUnit.stats.live.moves) or (selectedUnit.stats.live.moves == 0) then
				destroyMenu()
			else
				print "Can't cancel. Unit already used."
				local unit = selectedUnit
				destroyMenu()
				createMenu(unit)
			end
		end
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
				if selectedUnit.movModeIsMove then
					selectedUnit:tryMove(touch, opposition, teammates)
				elseif not (selectedUnit.movModeIsMove or (menu == nil)) then
					selectedUnit:tryAttack(touch, opposition)
				end
			elseif menu == nil then
				--check friendly units for touch
				for i in pairs(teammates) do
					if teammates[i]:isAt(touch) and not touch.hit then
						print ("Unit touched!")
						createMenu(teammates[i])
						touch.hit = true
					end
				end
				
				--check enemy units for touch
				for i in pairs(opposition) do
					if opposition[i]:isAt(touch) and not touch.hit then
						print ("Enemy unit touched!")
						touch.hit = true
					end
				end
			end
			
			if not touch.hit then
				cancelled = true
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
			
			checkIfEnded()
		end
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("overlayBegan")
scene:addEventListener("overlayEnded")

return scene