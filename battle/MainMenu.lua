local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene(event)
    local screenGroup = self.view
end

function scene:enterScene(event)
    local screenGroup = self.view
	salute = display.newImage("assets/salute.png", 50, 20)
	startButton = display.newImage("assets/start_button.png", 60, 350)
	startButton:addEventListener("touch", startTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	salute:removeSelf()
	startButton:removeSelf()
	startButton:removeEventListener("touch", startTouch)
end

startTouch = function(event)
	storyboard.gotoScene("Level", options)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene