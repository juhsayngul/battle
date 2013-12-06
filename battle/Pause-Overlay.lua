local storyboard = require( "storyboard" )
local sfx = require("sfx")

local scene = storyboard.newScene()

local resumeButton, quitButton
local pauseText

local destination

function scene:createScene(event)
    local screenGroup = self.view
	
	pauseText = display.newText("PAUSED", 0, 0, native.systemFontBold, 22)
	pauseText.x, pauseText.y = 240, 30
	pauseText:setTextColor(0, 0, 255)
	
	resumeButton = display.newImage("assets/resume_button.png", 0, 0)
	quitButton = display.newImage("assets/quit_button.png", 0, 0)
	
	resumeButton.x, resumeButton.y = 160, 150
	quitButton.x, quitButton.y = 160, 195
	
	screenGroup:insert(pauseText)
	screenGroup:insert(resumeButton)
	screenGroup:insert(quitButton)
	
	resumeButton:toFront()
	quitButton:toFront()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	destination = event.params.destination
	
	resumeButton:addEventListener("touch", resumeTouch)
	quitButton:addEventListener("touch", quitTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	resumeButton:removeEventListener("touch", resumeTouch)
	quitButton:removeEventListener("touch", quitTouch)
end

resumeTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		storyboard.hideOverlay("slideDown", 300)
	end
end

quitTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		local options = {
			effect = "slideDown",
			time = 300,
			params = {
				unlockNextLevel = false,
				removeLevelScene = true
			}
		}
		storyboard.gotoScene(destination, options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene