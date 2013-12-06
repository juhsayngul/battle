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
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.x + newStats.attackText.width / 2) + i * 7, 380)
			newStats.imageGroup:insert(attackImage)
		end
		newStats.defendText = display.newText("DEFEND: ", 32, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (newStats.defendText.x + newStats.defendText.width / 2) + i * 7, 392)
			newStats.imageGroup:insert(defendImage)
		end
		newStats.rangeText = display.newText("RANGE: ", 32, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.x + newStats.rangeText.width / 2) + i * 7, 404)
			newStats.imageGroup:insert(rangeImage)
		end
	else
		newStats.attackText = display.newText("ATTACK: ", 32, 380, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.x + newStats.attackText.width / 2) + i * 7, 380)
			newStats.imageGroup:insert(attackImage)
		end
		newStats.defendText = display.newText("DEFEND: ", 32, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (newStats.defendText.x + newStats.defendText.width / 2) + i * 7, 392)
			newStats.imageGroup:insert(defendImage)
		end
		newStats.rangeText = display.newText("RANGE: ", 32, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.x + newStats.rangeText.width / 2) + i * 7, 404)
			newStats.imageGroup:insert(rangeImage)
		end
	end
	newStats.healthText = display.newText("HEALTH: ", 32, 416, native.systemFontBold, 12)
	for i=0, selectedUnit.stats.base.health - 1 do
			if i >= selectedUnit.stats.live.health then
				local healthImage = display.newImage("assets/health_meter_empty.png", (newStats.healthText.x + newStats.healthText.width / 2) + i * 7, 416)
				newStats.imageGroup:insert(healthImage)
			else
				local healthImage = display.newImage("assets/health_meter.png", (newStats.healthText.x + newStats.healthText.width / 2) + i * 7, 416)
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

function StatsOverlay:update(selectedUnit)
	display.remove(self.imageGroup)
	self.imageGroup = nil
	newStats.imageGroup = {}
	newStats.imageGroup = display.newGroup()
	if selectedUnit.atkModeIsMelee then
		for i=0, selectedUnit.stats.live.ranged.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.x + newStats.attackText.width / 2) + i * 7, 380)
			self.imageGroup:insert(attackImage)
		end
		for i=0, selectedUnit.stats.live.ranged.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (newStats.defendText.x + newStats.defendText.width / 2) + i * 7, 392)
			self.imageGroup:insert(defendImage)
		end
		for i=0, selectedUnit.stats.live.ranged.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.x + newStats.rangeText.width / 2) + i * 7, 404)
			self.imageGroup:insert(rangeImage)
		end
	else
		for i=0, selectedUnit.stats.live.melee.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (newStats.attackText.x + newStats.attackText.width / 2) + i * 7, 380)
			self.imageGroup:insert(attackImage)
		end
		for i=0, selectedUnit.stats.live.melee.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (newStats.defendText.x + newStats.defendText.width / 2) + i * 7, 392)
			self.imageGroup:insert(defendImage)
		end
		for i=0, selectedUnit.stats.live.melee.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (newStats.defendText.x + newStats.rangeText.width / 2) + i * 7, 404)
			self.imageGroup:insert(rangeImage)
		end
	end
	for i=0, selectedUnit.stats.base.health - 1 do
			if i >= selectedUnit.stats.live.health then
				local healthImage = display.newImage("assets/health_meter_empty.png", (newStats.healthText.x + newStats.healthText.width / 2) + i * 7, 416)
				self.imageGroup:insert(healthImage)
			else
				local healthImage = display.newImage("assets/health_meter.png", (newStats.healthText.x + newStats.healthText.width / 2) + i * 7, 416)
				self.imageGroup:insert(healthImage)
			end
	end
	newStats.group:insert(newStats.imageGroup)
end

function StatsOverlay:enemyStats(selectedUnit, melee)
	self = {}
	self.group = display.newGroup()
	self.imageGroup = {}
	self.imageGroup = display.newGroup()
	if melee then
		self.attackText = display.newText("ATTACK: " , 160, 380, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (self.attackText.x + self.attackText.width / 2) + i * 7, 380)
			self.imageGroup:insert(attackImage)
		end
		self.defendText = display.newText("DEFEND: ", 160, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (self.defendText.x + self.defendText.width / 2) + i * 7, 392)
			self.imageGroup:insert(defendImage)
		end
		self.rangeText = display.newText("RANGE: ", 160, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.melee.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (self.rangeText.x + self.rangeText.width / 2) + i * 7, 404)
			self.imageGroup:insert(rangeImage)
		end
	else
		self.attackText = display.newText("ATTACK: " , 160, 380, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.atk - 1 do
			local attackImage = display.newImage("assets/attack_meter.png", (self.attackText.x + self.attackText.width / 2) + i * 7, 380)
			self.imageGroup:insert(attackImage)
		end
		self.defendText = display.newText("DEFEND: ", 160, 392, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.def - 1 do
			local defendImage = display.newImage("assets/defend_meter.png", (self.defendText.x + self.defendText.width / 2) + i * 7, 392)
			self.imageGroup:insert(defendImage)
		end
		self.rangeText = display.newText("RANGE: ", 160, 404, native.systemFontBold, 12)
		for i=0, selectedUnit.stats.live.ranged.rng - 1 do
			local rangeImage = display.newImage("assets/range_meter.png", (self.rangeText.x + self.rangeText.width / 2) + i * 7, 404)
			self.imageGroup:insert(rangeImage)
		end
	end
	self.healthText = display.newText("HEALTH: ", 160, 416, native.systemFontBold, 12)
	for i=0, selectedUnit.stats.base.health - 1 do
			if i >= selectedUnit.stats.live.health then
				local healthImage = display.newImage("assets/health_meter_empty.png", (self.healthText.x + self.healthText.width / 2) + i * 7, 416)
				self.imageGroup:insert(healthImage)
			else
				local healthImage = display.newImage("assets/health_meter.png", (self.healthText.x + self.healthText.width / 2) + i * 7, 416)
				self.imageGroup:insert(healthImage)
			end
	end
	self.group:insert(self.attackText)
	self.group:insert(self.defendText)
	self.group:insert(self.rangeText)
	self.group:insert(self.healthText)
	self.group:insert(self.imageGroup)
	setmetatable(self, StatsOverlay)
	return self
end

return StatsOverlay