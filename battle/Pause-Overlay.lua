-- This pause scene still requires work but it's just getting the idea in place
local LevelParams = require("LevelParams")
local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

local resumeButton

function scene:createScene(event)
    local screenGroup = self.view
	
	-- just to get us going, using the title screen's start button
	resumeButton = display.newImage("assets/resume_button.png", 60, 125)
	restartButton = display.newImage("assets/restart_button.png", 60, 175)
	quitButton = display.newImage("assets/quit_button.png", 60, 225)
	
	screenGroup:insert(resumeButton)
	screenGroup:insert(restartButton)
	screenGroup:insert(quitButton)
	resumeButton:toFront()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	resumeButton:addEventListener("touch", resumeTouch)
	restartButton:addEventListener("touch", restartTouch)
	quitButton:addEventListener("touch", quitTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	resumeButton:removeEventListener("touch", resumeTouch)
end

resumeTouch = function(event)
	if event.phase == "ended" then
		storyboard.hideOverlay("slideDown", 300)
	end
end

restartTouch = function(event)
	if event.phase == "ended" then
	end
end

quitTouch = function(event)
	if event.phase == "ended" then
		local options = {
			effect = "slideDown",
			time = 300,
			params = {}
		}
		storyboard.gotoScene("Title-Screen", options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene