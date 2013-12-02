local StatsOverlay = {}
StatsOverlay.__index = StatsOverlay

function StatsOverlay.new(selectedUnit)
	newStats = {}
	newStats.group = display.newGroup()
	newStats.imageGroup = {}
	newStats.imageGroup = display.newGroup()
	
	if selectedUnit.atkModeIsMelee then
		newStats.attackText = display.newText("ATTACK: " , 32, 380, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.width * 1.5) + i * 7, 380)
			newStats.imageGroup:insert(attackImage)
		end
		newStats.defendText = display.newText("DEFEND: ", 32, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (newStats.defendText.width * 1.5) + i * 7, 392)
			newStats.imageGroup:insert(defendImage)
		end
		newStats.rangeText = display.newText("RANGE: ", 32, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.width * 1.5) + i * 7, 404)
			newStats.imageGroup:insert(rangeImage)
		end
	else
		newStats.attackText = display.newText("ATTACK: " .. selectedUnit.stats.live.ranged.atk, 32, 380, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.width * 1.5) + i * 7, 380)
			newStats.imageGroup:insert(attackImage)
		end
		newStats.defendText = display.newText("DEFEND: ", 32, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.def - 1 do
			display.newImage("assets/defend_meter.png", (newStats.defendText.width * 1.5) + i * 7, 392)
			newStats.imageGroup:insert(defendImage)
		end
		newStats.rangeText = display.newText("RANGE: ", 32, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.width * 1.5) + i * 7, 404)
			newStats.imageGroup:insert(rangeImage)
		end
	end
	newStats.healthText = display.newText("HEALTH: ", 32, 416, native.systemFontBold, 12)
	for i=0, selectedUnit.stats.base.health - 1 do
			if i >= selectedUnit.stats.live.health then
				local healthImage = display.newImage("assets/health_meter_empty.png", (newStats.healthText.width * 1.5) + i * 7, 416)
				newStats.imageGroup:insert(healthImage)
			else
				local healthImage = display.newImage("assets/health_meter.png", (newStats.healthText.width * 1.5) + i * 7, 416)
				newStats.imageGroup:insert(healthImage)
			end
	end
	newStats.group:insert(newStats.imageGroup)
	newStats.group:insert(newStats.attackText)
	newStats.group:insert(newStats.defendText)
	newStats.group:insert(newStats.rangeText)
	newStats.group:insert(newStats.healthText)
	setmetatable(newStats, StatsOverlay)
	return newStats
end

function StatsOverlay:destroy()
	display.remove(self.group)
end

return StatsOverlay