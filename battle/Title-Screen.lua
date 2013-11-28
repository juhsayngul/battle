local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")

local scene = storyboard.newScene()

local options = {
	effect = "slideUp",
	time = 300,
	params = LevelParams.getLevelParams("Level-1")
}

local salute, startButton
local startTouch

function scene:createScene(event)
    local screenGroup = self.view
	
	salute = display.newImage("assets/salute.png", 50, 20)
	startButton = display.newImage("assets/start_button.png", 60, 350)
	screenGroup:insert(salute)
	screenGroup:insert(startButton)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	startButton:addEventListener("touch", startTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	startButton:removeEventListener("touch", startTouch)
end

startTouch = function(event)
	if event.phase == "ended" then
		storyboard.gotoScene("Level", options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene