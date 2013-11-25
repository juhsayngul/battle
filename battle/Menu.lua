local Menu = {}
Menu.__index = Menu

function Menu.new(buttonListener, selectedUnit)
	newMenu = {}
	newMenu.group = display.newGroup()
	
	newMenu.button = {}
	newMenu.button.group = display.newGroup()
	
	newMenu.button.move = display.newImage("assets/move.png", 32, 325)
	if selectedUnit.atkMelee then
		newMenu.button.switch = display.newImage("assets/ranged.png", 102, 325)
	else
		newMenu.button.switch = display.newImage("assets/melee.png", 102, 325)
	end
	newMenu.button.defend = display.newImage("assets/defend.png", 172, 325)
	newMenu.button.cancel = display.newImage("assets/cancel.png", 242, 325)
	
	newMenu.button.move:addEventListener("touch", buttonListener.move)
	newMenu.button.switch:addEventListener("touch", buttonListener.switch)
	newMenu.button.defend:addEventListener("touch", buttonListener.defend)
	newMenu.button.cancel:addEventListener("touch", buttonListener.cancel)
	
	newMenu.button.group:insert(newMenu.button.move)
	newMenu.button.group:insert(newMenu.button.switch)
	newMenu.button.group:insert(newMenu.button.defend)
	newMenu.button.group:insert(newMenu.button.cancel)
	
	newMenu.moveText = display.newText("Moves remaining: " .. selectedUnit.stats.live.moves, 185, 25, native.systemFontBold, 12)
	
	newMenu.group:insert(newMenu.button.group)
	newMenu.group:insert(newMenu.moveText)
	
	setmetatable(newMenu, Menu)
	return newMenu
end

function Menu:destroy(buttonListener)
	
	self.button.move:removeEventListener("touch", buttonListener.move)
	self.button.switch:removeEventListener("touch", buttonListener.switch)
	self.button.defend:removeEventListener("touch", buttonListener.defend)
	self.button.cancel:removeEventListener("touch", buttonListener.cancel)
	
	display.remove(self.group)
end

function Menu:switch(buttonListener, melee)
		self.button.switch:removeEventListener("touch", buttonListener.switch)
		self.button.switch:removeSelf()
		self.button.switch = nil
	if melee then
		self.button.switch = display.newImage("assets/melee.png", 102, 325)
	else
		self.button.switch = display.newImage("assets/ranged.png", 102, 325)
	end
	self.button.group:insert(newMenu.button.switch)
	self.button.switch:addEventListener("touch", buttonListener.switch)
end

return Menu