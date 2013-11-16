local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(params)
	local newEnemy = {}
	newEnemy.name = params.name
	local sheetData = nil
	local imageSheet = nil
	local sequenceData = nil
	if newEnemy.name == "Infantry" then
		sheetData = {width = 32, height = 36, numFrames = 6, sheetContentWidth = 192, sheetContentHeight = 36}
		imageSheet = graphics.newImageSheet("assets/enemy_infantry_anim.png", sheetData)
		sequenceData = 
		{
			{
				name = "idle_right",
				frames = {1, 2, 3, 2},
				time = 500,
				loopCount = 0
			},
			{
				name = "idle_left",
				frames = {4, 5, 6, 5},
				time = 500,
				loopCount = 0
			}
		}
	elseif newEnemy.name == "Tank" then
		sheetData = {width = 32, height = 32, numFrames = 4, sheetContentWidth = 128, sheetContentHeight = 32}
		imageSheet = graphics.newImageSheet("assets/enemy_tank_anim.png", sheetData)
		sequenceData = 
		{
			{
				name = "idle_right",
				frames = {1, 2},
				time = 250,
				loopCount = 0
			},
			{
				name = "idle_left",
				frames = {3, 4},
				time = 250,
				loopCount = 0
			}
		}
	end
	newEnemy.posX = params.posX
	newEnemy.posY = params.posY
	newEnemy.moves = params.moves
	newEnemy.melee = params.melee
	newEnemy.anim = display.newSprite(imageSheet, sequenceData)
	newEnemy.anim:setReferencePoint(display.TopLeftReferencePoint)
	newEnemy.anim.x = (params.posX * 32) + 32
	newEnemy.anim.y = (params.posY * 32) + 60
	newEnemy.anim:play()
	newEnemy.group = display.newGroup()
	setmetatable(newEnemy, Enemy)
	return newEnemy
end

return Enemy