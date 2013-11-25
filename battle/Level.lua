local Board = require( "Board" )
local storyboard = require( "storyboard" )
-- local BG = require( "BG" )
local Unit = require ("Unit")
local Menu = require ("Menu")

local scene = storyboard.newScene()

local Level = {}
Level.__index = Level

local moving = false
local cancelled = false
local attacking = false

local buttonListener = {}
local menu = nil
	
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

buttonListener.move = function (event)
	if event.phase == "ended" then
		menu.moveText.text = "Where will you move to?"
		moving = true
		attacking = false
	end
end

buttonListener.switch = function (event)
	if event.phase == "ended" then
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
		attacking = false
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
	
	local touch = {
		x = math.floor((event.x - 32) / 32),
		y = math.floor((event.y - 60) / 32),
		hit = false
	}
	
	if event.phase == "ended" then
		--if grid is touched
		if (touch.x >= 0 and touch.x < 8) and (touch.y >= 0 and touch.y < 8) then
			if moving then
				selectedUnit:tryMove(touch, enemies, friends)
				moving = false
			elseif attacking then
				selectedUnit:tryAttack(touch, enemies)
				attacking = false
			elseif menu == nil then
				--check friendly units for touch
				for i in pairs(friends) do
					if friends[i]:isAt(touch) and not touch.hit then
						print ("Unit touched!")
						createMenu(friends[i])
						touch.hit = true
						print ("Attacking!")
						attacking = true
					end
				end
				
				--check enemy units for touch
				for i in pairs(enemies) do
					if enemies[i]:isAt(touch) and not touch.hit then
						print ("Enemy unit touched!")
						touch.hit = true
					end
				end
			end
			
			if not touch.hit then
				destroyMenu()
			end
			
			for i in pairs(enemies) do
				if enemies[i].toDie then
					table.remove(enemies, i)
				end
				if friends[i].toDie then
					table.remove(friends, i)
				end
			end
		end
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene