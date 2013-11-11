local storyboard = require( "storyboard" )
local Level = require( "Level" )

local scene = storyboard.newScene()

local level

local _W = display.contentWidth
local _H = display.contentHeight

local levelParams = {name = "Level 1",
	boardParams = {name = "Board 1"},
	bgParams = {name = "BG 1", posX = 0, posY = 0, x = _W, y = _H}
}

function scene:createScene(event)
    local screenGroup = self.view
	
	level = Level.new(levelParams)
	screenGroup:insert(level.group)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
    -- storyboard.removeScene("title-screen")
	level:listen()
end

function scene:exitScene(event)
    local screenGroup = self.view
	
end

local function onEveryFrame(event)
	
end

Runtime:addEventListener("enterFrame", onEveryFrame)

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene