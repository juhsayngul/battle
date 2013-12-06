local Menu = {}
Menu.__index = Menu
local sfx = require("sfx")

function Menu.new(buttonListener, selectedUnit)
	newMenu = {}
	newMenu.group = display.newGroup()
	
	newMenu.button = {}
	newMenu.button.group = display.newGroup()
	
	if selectedUnit.movModeIsMove then
		newMenu.button.switchMov = display.newImage("assets/attack.png", 32, 325)
	else
		newMenu.button.switchMov = display.newImage("assets/move.png", 32, 325)
	end
	
	if selectedUnit.atkModeIsMelee then
		if (selectedUnit.stats.live.ranged.atk > 0) then
			newMenu.button.switchAtk = display.newImage("assets/ranged.png", 102, 325)
		else
			newMenu.button.switchAtk = display.newImage("assets/ranged_na.png", 102, 325)
		end
	else
		if (selectedUnit.stats.live.melee.atk > 0) then
			newMenu.button.switchAtk = display.newImage("assets/melee.png", 102, 325)
		else
			newMenu.button.switchAtk = display.newImage("assets/melee_na.png", 102, 325)
		end
	end
	
	newMenu.button.defend = display.newImage("assets/defend.png", 172, 325)
	if (selectedUnit.stats.live.moves == selectedUnit.stats.base.moves) then
		newMenu.button.cancel = display.newImage("assets/cancel.png", 242, 325)
	else
		newMenu.button.cancel = display.newImage("assets/inspect.png", 242, 325)
	end
	
	newMenu.button.switchMov:addEventListener("touch", buttonListener.switchMov)
	newMenu.button.switchAtk:addEventListener("touch", buttonListener.switchAtk)
	newMenu.button.defend:addEventListener("touch", buttonListener.defend)
	newMenu.button.cancel:addEventListener("touch", buttonListener.cancel)
	
	newMenu.button.group:insert(newMenu.button.switchMov)
	newMenu.button.group:insert(newMenu.button.switchAtk)
	newMenu.button.group:insert(newMenu.button.defend)
	newMenu.button.group:insert(newMenu.button.cancel)
	
	newMenu.moveText = display.newText("Moves remaining: " .. selectedUnit.stats.live.moves, 0, 0, native.systemFontBold, 12)
	newMenu.moveText.x, newMenu.moveText.y = 250, 460
	
	newMenu.group:insert(newMenu.button.group)
	newMenu.group:insert(newMenu.moveText)
	
	setmetatable(newMenu, Menu)
	return newMenu
end

function Menu:destroy(buttonListener)
	self.button.switchMov:removeEventListener("touch", buttonListener.switchMov)
	self.button.switchAtk:removeEventListener("touch", buttonListener.switchAtk)
	self.button.defend:removeEventListener("touch", buttonListener.defend)
	self.button.cancel:removeEventListener("touch", buttonListener.cancel)
	
	display.remove(self.group)
end

function Menu:switchMov(buttonListener, move)
	audio.play(sfx.click)
	
	self.button.switchMov:removeEventListener("touch", buttonListener.switchMov)
	self.button.switchMov:removeSelf()
	self.button.switchMov = nil
	if move then
		self.button.switchMov = display.newImage("assets/attack.png", 32, 325)
	else
		self.button.switchMov = display.newImage("assets/move.png", 32, 325)
	end
	self.button.group:insert(newMenu.button.switchMov)
	self.button.switchMov:addEventListener("touch", buttonListener.switchMov)
end

function Menu:switchAtk(buttonListener, melee, selectedUnit)
	audio.play(sfx.click)
	self.button.switchAtk:removeEventListener("touch", buttonListener.switchAtk)
	self.button.switchAtk:removeSelf()
	self.button.switchAtk = nil
	if melee then
		if (selectedUnit.stats.live.melee.atk > 0) then
			newMenu.button.switchAtk = display.newImage("assets/melee.png", 102, 325)
		else
			newMenu.button.switchAtk = display.newImage("assets/melee_na.png", 102, 325)
		end
	else
		if (selectedUnit.stats.live.ranged.atk > 0) then
			newMenu.button.switchAtk = display.newImage("assets/ranged.png", 102, 325)
		else
			newMenu.button.switchAtk = display.newImage("assets/ranged_na.png", 102, 325)
		end
	end
	self.button.group:insert(newMenu.button.switchAtk)
	self.button.switchAtk:addEventListener("touch", buttonListener.switchAtk)
end

return Menu