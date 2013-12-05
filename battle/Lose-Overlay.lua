local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

local retryButton

function scene:createScene(event)
    local screenGroup = self.view
	
	retryButton = display.newImage("assets/restart_button.png", 60, 175)
	screenGroup:insert(retryButton)
	retryButton:toFront()
	
	-- "You lose"
	-- Retry
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	retryButton:addEventListener("touch", retryTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	retryButton:removeEventListener("touch", retryTouch)
end

retryTouch = function(event)
	if event.phase == "began" then
		local options = {
			effect = "slideDown",
			time = 300,
			params = {
				unlockNextLevel = false,
				removeLevelScene = true
			}
		}
		storyboard.gotoScene("Title-Screen", options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene