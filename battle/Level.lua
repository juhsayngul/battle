local Board = require( "Board" )
local storyboard = require( "storyboard" )
-- local BG = require( "BG" )
local Unit = require ("Unit")
local Menu = require ("Menu")

local scene = storyboard.newScene()

local Level = {}
Level.__index = Level

local cancelled = false

local buttonListener = {}
local menu = nil
local controlEnemies = false

local friends, enemies
local selectedUnit

local getUnits, getGroup, onEveryFrame, handleTouch

function scene:createScene(event)
    local screenGroup = self.view
	
	local params = event.params
	local bg, board, friendsGroup, enemiesGroup
	
	levelGroup = display.newGroup()
	
	board = Board.new(params.boardParams)
	-- bg = BG.new(params.bgParams)
	
	friends = getUnits(params.friendParams)
	enemies = getUnits(params.enemyParams)
	friendsGroup = getGroup(friends)
	enemiesGroup = getGroup(enemies)
	
	levelGroup:insert(friendsGroup)
	levelGroup:insert(enemiesGroup)
	levelGroup:insert(board.group)
	-- levelGroup:insert(bg.group)
	
	friendsGroup:toBack()
	enemiesGroup:toBack()
	board.group:toBack()
	-- bg.group:toBack()
	
	screenGroup:insert(levelGroup)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
    storyboard.removeScene("Title-Screen")
	
	Runtime:addEventListener("enterFrame", onEveryFrame)
	Runtime:addEventListener("touch", handleTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	Runtime:removeEventListener("enterFrame", onEveryFrame)
    Runtime:removeEventListener("touch", handleTouch)
end

local function createMenu(touchedUnit)
	selectedUnit = touchedUnit
	selectedUnit.defending = false
	menu = Menu.new(buttonListener, selectedUnit)
end

local function destroyMenu()
	if menu ~= nil then
		menu:destroy(buttonListener)
	end
	selectedUnit = nil
	menu = nil
end

buttonListener.attack = function (event)
	if event.phase == "ended" then
		menu.moveText.text = "Attack whom?"
		selectedUnit.movModeIsMove = false
		menu:switchToMove(buttonListener)
	end
end

buttonListener.move = function (event)
	if event.phase == "ended" then
		menu.moveText.text = "Where will you move to?"
		selectedUnit.movModeIsMove = true
		menu:switchToAttack(buttonListener)
	end
end

buttonListener.switch = function (event)
	if event.phase == "ended" then
		if selectedUnit.atkModeIsMelee and (selectedUnit.stats.live.ranged.atk > 0) or
		selectedUnit.atkModeIsMelee ~= true and (selectedUnit.stats.live.melee.atk > 0) then
			menu:switch(buttonListener, selectedUnit.atkModeIsMelee)
		end
		selectedUnit:switchAtk()
	end
end

buttonListener.defend = function (event)
	if event.phase == "ended" then
		print ("Defending!")
		selectedUnit.defending = true
	end
end

buttonListener.cancel = function (event)
	if event.phase == "ended" then
		print ("Cancelled")
		cancelled = true
		selectedUnit.movModeIsMove = false
		print("Attacking!")
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
	if cancelled == true then
		cancelled = false
		destroyMenu()
	end
end

handleTouch = function(event)
	local i
	local opposition, teammates
	
	-- for turns to work later
	if not controlEnemies then
		opposition = enemies
		teammates = friends
	else
		opposition = friends
		teammates = enemies
	end
	
	local touch = {
		x = math.floor((event.x - 32) / 32),
		y = math.floor((event.y - 60) / 32),
		hit = false
	}
	
	if event.phase == "ended" then
		--if grid is touched
		if (touch.x >= 0 and touch.x < 8) and (touch.y >= 0 and touch.y < 8) then
			if selectedUnit ~= nil then
				if selectedUnit.movModeIsMove then
					selectedUnit:tryMove(touch, opposition, teammates)
					selectedUnit.movModeIsMove = false
				elseif not (selectedUnit.movModeIsMove or (menu == nil)) then
					selectedUnit:tryAttack(touch, opposition)
					selectedUnit.movModeIsMove = true
				end
			elseif menu == nil then
				--check friendly units for touch
				for i in pairs(teammates) do
					if teammates[i]:isAt(touch) and not touch.hit then
						print ("Unit touched!")
						createMenu(teammates[i])
						touch.hit = true
						print ("Moving!")
						selectedUnit.movModeIsMove = true
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
				destroyMenu()
			end
			
			for i in pairs(opposition) do
				if opposition[i].toDie then
					table.remove(opposition, i)
				end
				if teammates[i].toDie then
					table.remove(teammates, i)
				end
			end
		end
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene