-- This pause scene still requires work but it's just getting the idea in place
local storyboard = require( "storyboard" )

local scene = storyboard.newScene()

local resumeButton

function scene:createScene(event)
    local screenGroup = self.view
	
	-- just to get us going, using the title screen's start button
	resumeButton = display.newImage("assets/start_button.png", 60, 200)
	
	screenGroup:insert(resumeButton)
	resumeButton:toFront()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	resumeButton:addEventListener("touch", resumeTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	resumeButton:removeEventListener("touch", resumeTouch)
end

resumeTouch = function(event)
	if event.phase == "ended" then
		local options = {
			effect = "slideDown",
			time = 300,
			params = {}
		}
		storyboard.hideOverlay(options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene