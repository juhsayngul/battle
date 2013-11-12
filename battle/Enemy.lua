local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(params)
	local newEnemy = {}
	newEnemy.name = params.name
	newEnemy.posX = params.posX
	newEnemy.posY = params.posY
	newEnemy.rect = display.newRect((params.posX * 32) + 32, (params.posY * 32) + 60, 32, 32)
	newEnemy.rect:setFillColor(0, 160, 255)
	newEnemy.group = display.newGroup()
	setmetatable(newEnemy, Enemy)
	print (newEnemy.name .. " created!")
	return newEnemy
end

return Enemy