local GUI = {}
GUI.__index = GUI

function GUI.new(buttonListener, selectedUnit)
	newGUI = {}
	newGUI.group = display.newGroup()
	
	newGUI.button = {}
	newGUI.button.group = display.newGroup()

	newGUI.button.pause = display.newImage("assets/pause_button.png", 32, 450)
	
	newGUI.button.pause:addEventListener("touch", buttonListener.pause)
	
	newGUI.button.group:insert(newGUI.button.pause)
	
	newGUI.group:insert(newGUI.button.group)
	
	setmetatable(newGUI, GUI)
	return newGUI
end

function GUI:destroy(buttonListener)
	
	self.button.move:removeEventListener("touch", buttonListener.move)
	self.button.switch:removeEventListener("touch", buttonListener.switch)
	self.button.defend:removeEventListener("touch", buttonListener.defend)
	self.button.cancel:removeEventListener("touch", buttonListener.cancel)
	
	display.remove(self.group)
end

return GUI