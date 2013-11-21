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
	
    -- storyboard.removeScene("title-screen")
end

function scene:exitScene(event)
    local screenGroup = self.view
	
end

buttonListener.move = function (event)
	if event.phase == "ended" then
		menu.moveText.text = "Where will you move to?"
		moving = true
	end
end

buttonListener.switch = function (event)
	if event.phase == "ended" then
		if level.unit[currentUnit].melee == true then
			level.unit[currentUnit].melee = false
		else
			level.unit[currentUnit].melee = true
		end
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

local function createMenu(melee)
	menu = Menu.new(buttonListener, melee, unitMovement)
end

local function destroyMenu()
	if menu ~= nil then
		menu:destroy(buttonListener)
	end
	menu = nil
end

local function onEveryFrame(event)
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

local function handleTouch(event)
	local i
	
	if event.phase == "ended" then
	--if grid is touched
		local touchX = math.floor((event.x - 32) / 32)
		local touchY = math.floor((event.y - 60) / 32)
		if touchX >= 0 and touchX < 8 and
		touchY >= 0 and touchY < 8 then
			--check if the space you touched has a friendly unit
			for i in pairs(level.unit) do
				if touchX == level.unit[i].posX and touchY == level.unit[i].posY then
					print ("Unit touched!")
					currentUnit = i
					unitMovement = level.unit[i].moves
					destroyMenu()
					createMenu(level.unit[i].melee) 
					break
				else
					destroyMenu()
				end
			end
			--check if the space you touched has an enemy unit
			for i in pairs(level.enemy) do
				if touchX == level.enemy[i].posX and touchY == level.enemy[i].posY then
					print ("Enemy unit touched!")
				end
			end
		end
	end
end

local function moveTouch(event)
	local i
	
	if event.phase == "ended" and moving == true then
		local check = true
		local touchX = math.floor((event.x - 32) / 32)
		local touchY = math.floor((event.y - 60) / 32)
		if touchX >= 0 and touchX < 8 and
		touchY >= 0 and touchY < 8 then
			for i in pairs(level.enemy) do
				if touchX == level.enemy[i].posX and touchY == level.enemy[i].posY then
					check = false
				end
			end
			local tempMovement = math.abs(level.unit[currentUnit].posX - touchX) + math.abs(level.unit[currentUnit].posY - touchY)
			if level.unit[currentUnit].posX - touchX > 0 then
				level.unit[currentUnit].anim:setSequence("idle_left")
				level.unit[currentUnit].anim:play()
			elseif level.unit[currentUnit].posX - touchX < 0 then
				level.unit[currentUnit].anim:setSequence("idle_right")
				level.unit[currentUnit].anim:play()
			end
			if tempMovement <= unitMovement and check == true then
				level.unit[currentUnit].posX = touchX
				level.unit[currentUnit].posY = touchY
				level.unit[currentUnit].anim.x = (touchX * 32) + 32
				level.unit[currentUnit].anim.y = (touchY * 32) + 60
			else
				if check == false then
					print ("An enemy is on that square.")
				else
					print ("Too far away!")
				end
			end
			moving = false
		end
	end
end

Runtime:addEventListener("enterFrame", onEveryFrame)
Runtime:addEventListener("touch", handleTouch)
Runtime:addEventListener("touch", moveTouch)

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene