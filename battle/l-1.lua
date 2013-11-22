local storyboard = require( "storyboard" )
local Level = require( "Level" )
local Menu = require ("Menu")

local scene = storyboard.newScene()

local level
local _W = display.contentWidth
local _H = display.contentHeight

local moving = false
local defending = false
local cancelled = false
local switched = false
local buttonListener = {}
local menu = nil

local selectedUnit

local onEveryFrame, handleTouch

local levelParams = {
	boardParams = {},
	bgParams = {posX = 0, posY = 0, x = _W, y = _H},
	unitParams = {
					{unitType = "infantry_f", posX = 0, posY = 0, moves = 3, melee = true},
					{unitType = "tank_f", posX = 7, posY = 0, moves = 7, melee = false}
				},
	enemyParams = {
					{unitType = "infantry_e", posX = 7, posY = 7, moves = 3, melee = true},
					{unitType = "tank_e", posX = 0, posY = 7, moves = 2, melee = false}
				}
}

function scene:createScene(event)
    local screenGroup = self.view
	
	level = Level.new(levelParams)
	screenGroup:insert(level.group)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	Runtime:addEventListener("enterFrame", onEveryFrame)
	Runtime:addEventListener("touch", handleTouch)
    storyboard.removeScene("MainMenu")
end

function scene:exitScene(event)
    local screenGroup = self.view
	
    Runtime:removeEventListener("enterFrame", onEveryFrame)
    Runtime:removeEventListener("touch", handleTouch)
end

buttonListener.move = function (event)
	if event.phase == "ended" then
		menu.moveText.text = "Where will you move to?"
		moving = true
	end
end

buttonListener.switch = function (event)
	if event.phase == "ended" then
		selectedUnit:switchAtk()
		switched = true
	end
end

buttonListener.defend = function (event)
	if event.phase == "ended" then
		print ("Defending!")
		defending = true
	end
end

buttonListener.cancel = function (event)
	if event.phase == "ended" then
		print ("Cancelled")
		cancelled = true
	end
end

local function createMenu(unit)
	selectedUnit = unit
	menu = Menu.new(buttonListener, selectedUnit)
end

local function destroyMenu()
	if menu ~= nil then
		menu:destroy(buttonListener)
	end
	selectedUnit = nil
	menu = nil
end

onEveryFrame = function(event)
	level:onEveryFrame(event)
	
	if switched == true then
		switched = false
		destroyMenu()
	end
	if defending == true then
		defending = false
		destroyMenu()
	end
	if cancelled == true then
		cancelled = false
		destroyMenu()
	end
end

handleTouch = function(event)
	level:handleTouch(event)
	
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
				selectedUnit:tryMove(touch, level.enemy, level.unit)
				moving = false
			elseif menu == nil then
				--check friendly units for touch
				for i in pairs(level.unit) do
					if level.unit[i]:isAt(touch) and not touch.hit then
						print ("Unit touched!")
						createMenu(level.unit[i])
						touch.hit = true
					end
				end
				
				--check enemy units for touch
				for i in pairs(level.enemy) do
					if level.enemy[i]:isAt(touch) and not touch.hit then
						print ("Enemy unit touched!")
						touch.hit = true
					end
				end
			end
			
			if not touch.hit then
				destroyMenu()
			end
		end
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene