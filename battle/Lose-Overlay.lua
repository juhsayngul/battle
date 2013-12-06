local storyboard = require( "storyboard" )
local sfx = require("sfx")

local scene = storyboard.newScene()

local retryButton, loseText

local destination

function scene:createScene(event)
    local screenGroup = self.view
	
	loseText = display.newText("YOU LOSE!", 0, 0, native.systemFontBold, 22)
	loseText.x, loseText.y = 220, 30
	loseText:setTextColor(255, 0, 0)
	
	retryButton = display.newImage("assets/quit_button.png", 60, 175)
	
	retryButton.x, retryButton.y = 160, 190
	
	screenGroup:insert(loseText)
	screenGroup:insert(retryButton)
	retryButton:toFront()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	destination = event.params.destination
	
	retryButton:addEventListener("touch", retryTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	retryButton:removeEventListener("touch", retryTouch)
end

retryTouch = function(event)
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