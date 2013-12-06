local storyboard = require( "storyboard" )
local sfx = require("sfx")

local scene = storyboard.newScene()

local continueButton, winText

local destination

function scene:createScene(event)
    local screenGroup = self.view
	
	winText = display.newText("YOU WIN!", 0, 0, native.systemFontBold, 22)
	winText.x, winText.y = 230, 30
	winText:setTextColor(0, 255, 0)
	
	continueButton = display.newImage("assets/quit_button.png", 60, 175)
	
	continueButton.x, continueButton.y = 160, 190
	
	screenGroup:insert(winText)
	screenGroup:insert(continueButton)
	continueButton:toFront()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	destination = event.params.destination
	
	continueButton:addEventListener("touch", continueTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	continueButton:removeEventListener("touch", continueTouch)
end

continueTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		local options = {
			effect = "slideDown",
			time = 300,
			params = {
				unlockNextLevel = true,
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