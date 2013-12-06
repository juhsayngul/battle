local storyboard = require( "storyboard" )
local LevelParams = require("LevelParams")
local sfx = require("sfx")

local scene = storyboard.newScene()

local _W = display.contentWidth

local finalPage
local currentPage
local removeHowToScene

local screenTouch
local image

function scene:createScene(event)
    local screenGroup = self.view
	
	finalPage = event.params.finalPage
	currentPage = event.params.page
	removeHowToScene = event.params.removeHowToScene
	
	image = display.newImage("assets/how-to/"..currentPage..".png", 0, 0)
	
	screenGroup:insert(image)
end

function scene:enterScene(event)
    local screenGroup = self.view
	
	if removeHowToScene then
		storyboard.removeScene("How-To-Even")
	end
	
	Runtime:addEventListener("touch", screenTouch)
end

function scene:exitScene(event)
    local screenGroup = self.view
	
	Runtime:removeEventListener("touch", screenTouch)
end

screenTouch = function(event)
	if event.phase == "began" then
		audio.play(sfx.click)
		if (event.x < (_W/2)) then
			if currentPage > 1 then
				options = {
					effect = "slideRight",
					time = 100,
					params = {
						finalPage = finalPage,
						page = currentPage - 1,
						removeHowToScene = true
					}
				}
				storyboard.gotoScene("How-To-Even", options)
			else
				options = {
					effect = "slideRight",
					time = 100,
					params = {
						fromPage = currentPage,
						removeHowToScene = true
					}
				}
				storyboard.gotoScene("Title-Screen", options)
			end
		else
			if currentPage < finalPage then
				options = {
					effect = "slideLeft",
					time = 100,
					params = {
						finalPage = finalPage,
						page = currentPage + 1,
						removeHowToScene = true
					}
				}
				storyboard.gotoScene("How-To-Even", options)
			else
				options = {
					effect = "slideLeft",
					time = 100,
					params = {
						fromPage = currentPage,
						removeHowToScene = true
					}
				}
				storyboard.gotoScene("Title-Screen", options)
			end
		end
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)

return scene