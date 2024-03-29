local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")
local json = require("json")
local sfx = require("sfx")

local scene = storyboard.newScene()

local options

local levelNames = {}
levelNames[1] = "1: Don't back down"
levelNames[2] = "2: Tiananmen Square"
levelNames[3] = "3: That's not fair"
levelNames[4] = "4: Horsey!"
levelNames[5] = "5: Welcome to Earth"
levelNames[6] = "6: Calling for backup!"
levelNames[7] = "7: WOAH! Look out!"
levelNames[8] = "8: Vaguely familiar..."
levelNames[9] = "9: Can't trust anyone"
levelNames[10] = "10: Have fun with that"

local salute, howToButton, winnerTrophy
local blankButton, startButton, twoPlayerButton
local startTouch

local leftArrow, leftArrowGray, rightArrow, rightArrowGray, levelBox, levelText
local leftArrowTouch, rightArrowTouch, updateLevel

local levelProgress, levelSelection
local winner = false
local maxLevel = 10

local loadLevelProgress, saveLevelProgress

function scene:createScene(event)
    local screenGroup = self.view
	
	sfx.channels.bgm = audio.play(sfx.menu, {loops=-1})
	
	salute = display.newImage("assets/salute.png", 50, 20)
	salute.x = 160
	howToButton = display.newImage("assets/how_to_play.png", 255, 10)
	title = display.newImage("assets/battle383.png", 0, 200)
	
	leftArrow = display.newImage("assets/arrow_left.png", 320, 330)
	leftArrowGray = display.newImage("assets/arrow_left_gray.png", 25, 330)
	rightArrow = display.newImage("assets/arrow_right.png", 320, 330)
	rightArrowGray = display.newImage("assets/arrow_right_gray.png", 260, 330)
	
	levelBox = display.newRect(0, 0, 180, 25)
	levelBox.x, levelBox.y = 160, 347.5
	levelText = display.newText(" ", 0, 0, native.systemFontBold, 16)
	levelText.x, levelText.y = 160, 347.5
	levelText:setTextColor(0, 0, 0)
	
	blankButton = display.newImage("assets/blank_button.png", 0, 0)
	blankButton.x, blankButton.y = 160, 390
	
	twoPlayerButton = display.newImage("assets/two_player_button.png", 0, 0)
	twoPlayerButton.x, twoPlayerButton.y = 160, 432.5
	
	screenGroup:insert(levelBox)
	screenGroup:insert(levelText)
	screenGroup:insert(leftArrow)
	screenGroup:insert(leftArrowGray)
	screenGroup:insert(rightArrow)
	screenGroup:insert(rightArrowGray)
	screenGroup:insert(salute)
	screenGroup:insert(title)
	screenGroup:insert(blankButton)
	screenGroup:insert(twoPlayerButton)
	screenGroup:insert(howToButton)
	
	salute:toBack()
	blankButton:toBack()
	howToButton:toBack()
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	if (event.params) then
		if (event.params.removeLevelScene) then
			storyboard.removeScene("Level")
			if (event.params.unlockNextLevel) and (levelSelection == levelProgress) then
				if levelProgress < maxLevel then
					levelProgress = levelProgress + 1
					winner = false
					saveLevelProgress()
				else
					winner = true
					saveLevelProgress()
				end
			end
		elseif (event.params.removeHowToScene) then
			if ((event.params.fromPage%2) > 0) then
				storyboard.removeScene("How-To-Odd")
			else
				storyboard.removeScene("How-To-Even")
			end
		elseif (event.params.removeTwoPlayerScene) then
			storyboard.removeScene("Two-Player")
		end
	end
	
	loadLevelProgress()
	if levelSelection == nil then
		levelSelection = levelProgress
	end
	
	if winnerTrophy == nil then
		if winner then
			winnerTrophy = display.newImage("assets/trophy.png", 20, 20)
			screenGroup:insert(winnerTrophy)
		end
	end
	
	if (startButton ~= nil) then
		display.remove(startButton)
	end
	if levelProgress > 1 then
		startButton = display.newImage("assets/continue_game_button.png", 0, 0)
	else
		startButton = display.newImage("assets/begin_game_button.png", 0, 0)
	end
	startButton.x, startButton.y = 160, 390
	
	screenGroup:insert(startButton)
	
	updateLevel()
	
	leftArrow:addEventListener("touch", leftArrowTouch)
	rightArrow:addEventListener("touch", rightArrowTouch)
	startButton:addEventListener("touch", startTouch)
	twoPlayerButton:addEventListener("touch", twoPlayerTouch)
	howToButton:addEventListener("touch", howToTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	leftArrow:removeEventListener("touch", leftArrowTouch)
	rightArrow:removeEventListener("touch", rightArrowTouch)
	startButton:removeEventListener("touch", startTouch)
	twoPlayerButton:removeEventListener("touch", twoPlayerTouch)
	howToButton:removeEventListener("touch", howToTouch)
end

startTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
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
		audio.play(sfx.click)
		options = {
			effect = "slideRight",
			time = 300,
			params = {
				finalPage = 5,
				page = 1
			}
		}
		storyboard.gotoScene("How-To-Odd", options)
	end
end

twoPlayerTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		options = {
			effect = "slideUp",
			time = 300,
			params = {
				finalPage = 4,
				page = 1,
				removeHowToScene = false
			}
		}
		storyboard.gotoScene("Two-Player", options)
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
		audio.play(sfx.click)
		if levelSelection > 1 then
			levelSelection = levelSelection - 1
		end
		updateLevel()
	end
end

rightArrowTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		if levelSelection < maxLevel and levelSelection < levelProgress then
			levelSelection = levelSelection + 1
		end
		updateLevel()
	end
end

saveLevelProgress = function()
	local myTable = {lp = levelProgress, w = winner}
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
		winner = myTable.w
    else
		levelProgress = 1
		winner = false
		saveLevelProgress()
	end
	if (levelProgress < 1) or (levelProgress > maxLevel) then
		levelProgress = 1
		winner = false
		saveLevelProgress()
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene