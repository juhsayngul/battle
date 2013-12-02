local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")

local scene = storyboard.newScene()

local options

local salute, startButton
local startTouch, loadLevel

local removeLevelScene = false
local currentLevel

local loadLevel, saveLevel

function scene:createScene(event)
    local screenGroup = self.view
	
	salute = display.newImage("assets/salute.png", 50, 20)
	startButton = display.newImage("assets/start_button.png", 60, 350)
	screenGroup:insert(salute)
	screenGroup:insert(startButton)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	if (event.params) then
		if (event.params.proceed) then
			saveLevel(event.params.nextLevelName)
			removeLevelScene = true
		end
	end
	
	if removeLevelScene then
		storyboard.removeScene("Level")
	end
	
	startButton:addEventListener("touch", startTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	startButton:removeEventListener("touch", startTouch)
end

startTouch = function(event)
	if event.phase == "began" then
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(loadLevel())
		}
		storyboard.gotoScene("Level", options)
	end
end

loadLevel = function()
	if (currentLevel == nil) then
		currentLevel = "Level-1"
	end
	return currentLevel
end

saveLevel = function(nextLevel)
	currentLevel = nextLevel
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene