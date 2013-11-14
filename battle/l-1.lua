local storyboard = require( "storyboard" )
local Level = require( "Level" )

local scene = storyboard.newScene()

local level
local _W = display.contentWidth
local _H = display.contentHeight
local moving = false

local levelParams = {name = "Level 1",
	boardParams = {name = "Board 1"},
	bgParams = {name = "BG 1", posX = 0, posY = 0, x = _W, y = _H},
	unitParams = {
					{name = "Infantry", posX = 0, posY = 0, moves = 3},
					{name = "Infantry", posX = 7, posY = 0, moves = 3}
				},
	enemyParams = {
					{name = "Infantry", posX = 7, posY = 7, moves = 3},
					{name = "Tank", posX = 0, posY = 7, moves = 2}
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
	level:listen()
end

function scene:exitScene(event)
    local screenGroup = self.view
	
end

local function onEveryFrame(event)
	
end

local function moveListener(event)
	if event.phase == "ended" then
		moveText.text = "Where will you move to?"
		moving = true
	end
end

local function createMenu()
	if move == nil then
		moveText = display.newText("Moves remaining: " .. unitMovement, 185, 325, native.systemFontBold, 12)
		move = display.newImage("move.png", 32, 325)
		move:addEventListener("touch", moveListener)
	end
end

local function destroyMenu()
	if move ~= nil then
		move:removeSelf()
		move:removeEventListener("touch", moveListener)
		moveText:removeSelf()
		if rect~= nil then
			rect:removeSelf()
		end
		move = nil
	end
end

local function handleTouch(event)
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
					createMenu() 
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
			if tempMovement <= unitMovement and check == true then
				level.unit[currentUnit].posX = touchX
				level.unit[currentUnit].posY = touchY
				level.unit[currentUnit].anim.x = (touchX * 32) + 32
				level.unit[currentUnit].anim.y = (touchY * 32) + 60
			else
				if check == false then
					print ("An ememy is on that square.")
				else
					print ("Too far away!")
				end
			end
			moving = false
			for i in pairs(level.unit) do
				if level.unit[i].posX >= 4 then
					level.unit[i].anim:setSequence("idle_left")
					level.unit[i].anim:play()
				else
					level.unit[i].anim:setSequence("idle_right")
					level.unit[i].anim:play()
				end
			end
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