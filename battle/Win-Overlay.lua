local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

local continueButton

function scene:createScene(event)
    local screenGroup = self.view
	
	levelParams = event.params
	
	continueButton = display.newImage("assets/resume_button.png", 60, 175)
	screenGroup:insert(continueButton)
	continueButton:toFront()
	
	-- "You won"
	-- Continue
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	continueButton:addEventListener("touch", continueTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	continueButton:removeEventListener("touch", continueTouch)
end

continueTouch = function(event)
	if event.phase == "began" then
		local options = {
			effect = "slideDown",
			time = 300,
			params = {
				nextLevelName = (levelParams.nextLevelName),
				proceed = true
			}
		}
		storyboard.gotoScene("Title-Screen", options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene