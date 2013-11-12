local storyboard = require( "storyboard" )
local Level = require( "Level" )

local scene = storyboard.newScene()

local level

local _W = display.contentWidth
local _H = display.contentHeight

local levelParams = {name = "Level 1",
	boardParams = {name = "Board 1"},
	bgParams = {name = "BG 1", posX = 0, posY = 0, x = _W, y = _H},
	unitParams = {
					{name = "Infantry", posX = 0, posY = 0},
					{name = "Tank", posX = 7, posY = 0}
				},
	enemyParams = {
					{name = "Infantry", posX = 7, posY = 7},
					{name = "Tank", posX = 0, posY = 7}
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

local function handleTouch(event)
	if event.phase == "ended" then
	--if grid is touched
		local touchX = math.floor((event.x - 32) / 32)
		local touchY = math.floor((event.y - 60) / 32)
		if event.x >= 32 and event.x < 32 + (32*8) and
		event.y >= 60 and event.y < 60 + (32 * 8) then
			print ("Touch at " .. touchX .. ", " .. touchY)
		end
		for i in pairs(level.unit) do
			if touchX == level.unit[i].posX and touchY == level.unit[i].posY then
				print ("Unit touched!")
			end
		end
		for i in pairs(level.enemy) do
			if touchX == level.enemy[i].posX and touchY == level.enemy[i].posY then
				print ("Enemy unit touched!")
			end
		end
	end
end

Runtime:addEventListener("enterFrame", onEveryFrame)
Runtime:addEventListener("touch", handleTouch)

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene