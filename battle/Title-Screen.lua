local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")

local scene = storyboard.newScene()

local options

local salute, startButton, howToButton
local startTouch, loadLevel

local levelProgress

local loadLevel, saveLevel
local menuBgm

function scene:createScene(event)
    local screenGroup = self.view
	
	salute = display.newImage("assets/salute.png", 50, 20)
	startButton = display.newImage("assets/start_button.png", 60, 350)
	howToButton = display.newImage("assets/inspect.png", 260, 10) -- placeholder button; probably shouldn't be circular anyway
	menuBgm = audio.loadSound( "audio/menu_loop.ogg" )
	
	screenGroup:insert(salute)
	screenGroup:insert(startButton)
	screenGroup:insert(howToButton)
	
	salute:toBack()
	startButton:toBack()
	howToButton:toBack()
end

function scene:enterScene(event)
    local screenGroup = self.view
	audio.play(menuBgm, {loops=-1})
	
	if (event.params) then
		if (event.params.proceed) then
			saveLevel(event.params.nextLevelName)
			storyboard.removeScene("Level")
		elseif (event.params.removeHowToScene) then
			if ((event.params.fromPage%2) > 0) then
				storyboard.removeScene("How-To-Odd")
			else
				storyboard.removeScene("How-To-Even")
			end
		end
	end
	
	startButton:addEventListener("touch", startTouch)
	howToButton:addEventListener("touch", howToTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	audio.dispose(menuBgm)
	menuBgm = nil
	
	startButton:removeEventListener("touch", startTouch)
	howToButton:removeEventListener("touch", howToTouch)
end

startTouch = function(event)
	if event.phase == "began" then
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(loadLevel())
		}
		storyboard.gotoScene("Level", options)
	end
end

howToTouch = function(event)
	if event.phase == "began" then
		options = {
			effect = "slideLeft",
			time = 300,
			params = {
				finalPage = 5,
				page = 1,
				removeHowToScene = false
			}
		}
		storyboard.gotoScene("How-To-Odd", options)
	end
end

loadLevel = function()
	if (levelProgress == nil) then
		levelProgress = "Level-1"
	end
	return levelProgress
end

saveLevel = function(nextLevel)
	levelProgress = nextLevel
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene