local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")
local sfx = require("sfx")

local scene = storyboard.newScene()

local _W, _H = display.contentWidth, display.contentHeight

local returnButton
local levelText, headerText
local levelBoxes

local levelNames = {}
levelNames[1] = "2P-1"
levelNames[2] = "2P-2"
levelNames[3] = "2P-3"
levelNames[4] = "2P-4"

local levelBoxTouch = {}

function scene:createScene(event)
    local screenGroup = self.view
	
	local boxWidth = 115
	
	levelBoxes = {}
	levelBoxes[1] = display.newRect(0, 0, boxWidth, boxWidth)
	levelBoxes[1]:setFillColor(255, 0, 0)
	levelBoxes[1].x, levelBoxes[1].y = 2.5*_W/9, 3*_H/9
	
	levelBoxes[2] = display.newRect(0, 0, boxWidth, boxWidth)
	levelBoxes[2]:setFillColor(0, 255, 0)
	levelBoxes[2].x, levelBoxes[2].y = 6.5*_W/9, 3*_H/9
	
	levelBoxes[3] = display.newRect(0, 0, boxWidth, boxWidth)
	levelBoxes[3]:setFillColor(0, 0, 255)
	levelBoxes[3].x, levelBoxes[3].y = 2.5*_W/9, 5.7*_H/9
	
	levelBoxes[4] = display.newRect(0, 0, boxWidth, boxWidth)
	levelBoxes[4]:setFillColor(255, 255, 0)
	levelBoxes[4].x, levelBoxes[4].y = 6.5*_W/9, 5.7*_H/9
	
	headerText = display.newText("TWO-PLAYER MODE", 0, 0, native.systemFontBold, 22)
	headerText.x, headerText.y = 160, 30
	
	levelText = display.newText("CHOOSE A LEVEL", 0, 0, native.systemFontBold, 22)
	levelText.x, levelText.y = 160, 60
	
	returnButton = display.newImage("assets/return_button.png", 0, 0)
	returnButton.x, returnButton.y = 160, 405
	
	screenGroup:insert(levelBoxes[1])
	screenGroup:insert(levelBoxes[2])
	screenGroup:insert(levelBoxes[3])
	screenGroup:insert(levelBoxes[4])
	screenGroup:insert(levelText)
	screenGroup:insert(headerText)
	screenGroup:insert(returnButton)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	if (event.params) then
		if (event.params.removeLevelScene) then
			storyboard.removeScene("Level-2P")
		end
	end
	
	levelBoxes[1]:addEventListener("touch", levelBoxTouch[1])
	levelBoxes[2]:addEventListener("touch", levelBoxTouch[2])
	levelBoxes[3]:addEventListener("touch", levelBoxTouch[3])
	levelBoxes[4]:addEventListener("touch", levelBoxTouch[4])
	returnButton:addEventListener("touch", continueTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	levelBoxes[1]:removeEventListener("touch", levelBoxTouch[1])
	levelBoxes[2]:removeEventListener("touch", levelBoxTouch[2])
	levelBoxes[3]:removeEventListener("touch", levelBoxTouch[3])
	levelBoxes[4]:removeEventListener("touch", levelBoxTouch[4])
	returnButton:removeEventListener("touch", continueTouch)
end

continueTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		local options = {
			effect = "slideDown",
			time = 300,
			params = {
				removeTwoPlayerScene = true
			}
		}
		storyboard.gotoScene("Title-Screen", options)
	end
end

levelBoxTouch[1] = function(event)
	if event.phase == "ended" then
		audio.play(sfx.click)
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(levelNames[1])
		}
		storyboard.gotoScene("Level-2P", options)
	end
end

levelBoxTouch[2] = function(event)
	if (event.phase == "began") then
		audio.play(sfx.click)
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(levelNames[2])
		}
		storyboard.gotoScene("Level-2P", options)
	end
end

levelBoxTouch[3] = function(event)
	if (event.phase == "began") then
		audio.play(sfx.click)
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(levelNames[3])
		}
		storyboard.gotoScene("Level-2P", options)
	end
end

levelBoxTouch[4] = function(event)
	if (event.phase == "began") then
		audio.play(sfx.click)
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(levelNames[4])
		}
		storyboard.gotoScene("Level-2P", options)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene