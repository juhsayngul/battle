local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W, _H = display.contentWidth, display.contentHeight
local levelParams = {
	levelName = "Level 1",
	boardParams = {},
	bgParams = {pos = {x = 0, y = 0}, length = {x = _W, y = _H}},
	friendParams = {
					{unitType = "cannon_f", pos = {x = 0, y = 7}},
					{unitType = "tank_f", pos = {x = 2, y = 7}},
					{unitType = "infantry_f", pos = {x = 5, y = 7}},
					{unitType = "heli_f", pos = {x = 7, y = 7}}
				},
	enemyParams = {
					{unitType = "infantry_e", pos = {x = 7, y = 0}},
					{unitType = "tank_e", pos = {x = 0, y = 0}}
				}
}

local options = {params = levelParams}

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