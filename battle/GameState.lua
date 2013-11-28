local GameState = {}
GameState.__index = GameState

function GameState.init()
	local newGameState = {}
	newGameState.isOrangeTurn = true
	print ("It is Orange's turn.")
	
	setmetatable(newGameState, GameState)
	return newGameState
end

function GameState:switch()
	if self.isOrangeTurn then
		self.isOrangeTurn = false
		print ("It is Blue's turn.")
	else
		self.isOrangeTurn = true
		print ("It is Orange's turn.")
	end
end

return GameState