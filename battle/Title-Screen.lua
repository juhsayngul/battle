local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")
local json = require("json")
local sfx = require("sfx")

local scene = storyboard.newScene()

local options

local levelNames = {}
levelNames[1] = "Level 1"
levelNames[2] = "Level 2"
levelNames[3] = "Level 3"
levelNames[4] = "Level 4"
levelNames[5] = "Level 5"
levelNames[6] = "Level 6"
levelNames[7] = "Level 7"
levelNames[8] = "Level 8"
levelNames[9] = "Level 9"

local salute, startButton, howToButton
local startTouch

local leftArrow, leftArrowGray, rightArrow, rightArrowGray, levelBox, levelText
local leftArrowTouch, rightArrowTouch, updateLevel

local levelProgress, levelSelection
local maxLevel = 9

local loadLevelProgress, saveLevelProgress

function scene:createScene(event)
    local screenGroup = self.view
	
	sfx.channels.bgm = audio.play(sfx.menu, {loops=-1})
	
	salute = display.newImage("assets/salute.png", 50, 20)
	salute.x = 160
	howToButton = display.newImage("assets/inspect.png", 260, 10) -- place holder button; probably shouldn't be circular anyway
	
	leftArrow = display.newImage("assets/arrow_left.png", 320, 330)
	leftArrowGray = display.newImage("assets/arrow_left_gray.png", 25, 330)
	rightArrow = display.newImage("assets/arrow_right.png", 320, 330)
	rightArrowGray = display.newImage("assets/arrow_right_gray.png", 260, 330)
	
	levelBox = display.newRect(0, 0, 180, 25)
	levelBox.x, levelBox.y = 160, 347.5
	levelText = display.newText(" ", 0, 0, native.systemFontBold, 16)
	levelText.x, levelText.y = 160, 347.5
	levelText:setTextColor(0, 0, 0)
	
	startButton = display.newImage("assets/start_button.png", 0, 0)
	startButton.x, startButton.y = 160, 390
	
	screenGroup:insert(levelBox)
	screenGroup:insert(levelText)
	screenGroup:insert(leftArrow)
	screenGroup:insert(leftArrowGray)
	screenGroup:insert(rightArrow)
	screenGroup:insert(rightArrowGray)
	screenGroup:insert(salute)
	screenGroup:insert(startButton)
	screenGroup:insert(howToButton)
	
	salute:toBack()
	startButton:toBack()
	howToButton:toBack()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	if (event.params) then
		if (event.params.removeLevelScene) then
			storyboard.removeScene("Level")
			if (event.params.unlockNextLevel) and (levelProgress == levelSelection) then
				if levelProgress < maxLevel then
					levelProgress = levelProgress + 1
					levelSelection = levelProgress
					saveLevelProgress()
				end
			end
		elseif (event.params.removeHowToScene) then
			if ((event.params.fromPage%2) > 0) then
				storyboard.removeScene("How-To-Odd")
			else
				storyboard.removeScene("How-To-Even")
			end
		end
	end
	
	loadLevelProgress()
	if levelSelection == nil then
		levelSelection = levelProgress
	end
	updateLevel()
	
	leftArrow:addEventListener("touch", leftArrowTouch)
	rightArrow:addEventListener("touch", rightArrowTouch)
	startButton:addEventListener("touch", startTouch)
	howToButton:addEventListener("touch", howToTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	leftArrow:removeEventListener("touch", leftArrowTouch)
	rightArrow:removeEventListener("touch", rightArrowTouch)
	startButton:removeEventListener("touch", startTouch)
	howToButton:removeEventListener("touch", howToTouch)
end

startTouch = function(event)
	if event.phase == "began" then
		options = {
			effect = "slideUp",
			time = 300,
			params = LevelParams.getLevelParams(levelNames[levelSelection])
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
				finalPage = 4,
				page = 1,
				removeHowToScene = false
			}
		}
		storyboard.gotoScene("How-To-Odd", options)
	end
end

updateLevel = function()
	local leftArrowXIn = 25+17.5
	local leftArrowXOut = 320+17.5
	
	local rightArrowXIn = 260+17.5
	local rightArrowXOut = 320+17.5
	
	if levelSelection > 1 then
		leftArrow.x = leftArrowXIn
		leftArrowGray.x = leftArrowXOut
	else
		leftArrow.x = leftArrowXOut
		leftArrowGray.x = leftArrowXIn
	end
	if (levelSelection < maxLevel) and (levelSelection < levelProgress) then
		rightArrow.x = rightArrowXIn
		rightArrowGray.x = rightArrowXOut
	else
		rightArrow.x = rightArrowXOut
		rightArrowGray.x = rightArrowXIn
	end
	
	levelText.text = levelNames[levelSelection]
	levelText.x, levelText.y = 160, 347.5
end

leftArrowTouch = function(event)
	if event.phase == "began" then
		if levelSelection > 1 then
			levelSelection = levelSelection - 1
		end
		updateLevel()
	end
end

rightArrowTouch = function(event)
	if event.phase == "began" then
		if levelSelection < maxLevel and levelSelection < levelProgress then
			levelSelection = levelSelection + 1
		end
		updateLevel()
	end
end

saveLevelProgress = function()
	local myTable = {lp = levelProgress}
    local path = system.pathForFile("progress", system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(myTable)
        file:write(contents)
        io.close(file)
    end
end

loadLevelProgress = function()
    local path = system.pathForFile("progress", system.DocumentsDirectory)
    local contents = ""
    local file = io.open( path, "r" )
    if file then
		local contents = file:read( "*a" )
		local myTable = {}
        myTable = json.decode(contents);
        io.close(file)
		levelProgress = myTable.lp
    else
		levelProgress = 1
		saveLevelProgress()
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene