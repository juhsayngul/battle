local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(params)
	local newEnemy = {}
	newEnemy.name = params.name
	newEnemy.posX = params.posX
	newEnemy.posY = params.posY
	newEnemy.moves = params.moves
	newEnemy.rect = display.newRect((params.posX * 32) + 32, (params.posY * 32) + 60, 32, 32)
	newEnemy.rect:setReferencePoint(display.TopLeftReferencePoint)
	newEnemy.rect:setFillColor(0, 160, 255)
	newEnemy.group = display.newGroup()
	setmetatable(newEnemy, Enemy)
	return newEnemy
end

return Enemy