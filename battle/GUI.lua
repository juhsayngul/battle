local GUI = {}
GUI.__index = GUI

local isOrange
local is2P

function GUI.new(buttonListener, isOrangeTurn, modeIsMultiplayer)
	local turnString
	local turnHeadPath
	isOrange = isOrangeTurn
	is2P = modeIsMultiplayer
	
	newGUI = {}
	newGUI.group = display.newGroup()
	
	newGUI.button = {}
	newGUI.button.group = display.newGroup()
	newGUI.button.pause = display.newImage("assets/pause_button.png", 32, 450)
	newGUI.button.pause:addEventListener("touch", buttonListener.pause)
	newGUI.button.group:insert(newGUI.button.pause)
	
	if isOrange then
		if is2P then
			turnString = "Orange turn"
		else
			turnString = "Your turn"
		end
		turnHeadPath = "assets/head_f.png"
	else
		if is2P then
			turnString = "Blue turn"
		else
			turnString = "CPU turn"
		end
		turnHeadPath = "assets/head_e.png"
	end
	newGUI.turnText = display.newText(turnString, 38, 16, native.systemFontBold, 12)
	newGUI.turnHead = display.newImage(turnHeadPath, 10, 10)
	
	newGUI.group:insert(newGUI.turnText)
	newGUI.group:insert(newGUI.turnHead)
	newGUI.group:insert(newGUI.button.group)
	
	newGUI.button.group:toBack()
	newGUI.turnText:toBack()
	newGUI.turnHead:toBack()
	
	setmetatable(newGUI, GUI)
	return newGUI
end

function GUI:destroy(buttonListener)
	self.button.pause:removeEventListener("touch", buttonListener.pause)
	
end

function GUI:switchTurn()
	local turnString
	local turnHeadPath
	
	if isOrange then
		isOrange = false
		if is2P then
			turnString = "Blue turn"
		else
			turnString = "CPU turn"
		end
		turnHeadPath = "assets/head_e.png"
	else
		isOrange = true
		if is2P then
			turnString = "Orange turn"
		else
			turnString = "Your turn"
		end
		turnHeadPath = "assets/head_f.png"
	end
	
	self.turnText.text = turnString
	self.turnHead:removeSelf()
	self.turnHead = display.newImage(turnHeadPath, 10, 10)
	
	self.group:insert(newGUI.turnHead)
	self.turnHead:toBack()
end

return GUI