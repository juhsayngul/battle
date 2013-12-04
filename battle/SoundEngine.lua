local SoundEngine = {}
SoundEngine.__index = SoundEngine

-- Not much to this yet; just a way to do sound

local sounds = {}
sounds["death"] = audio.loadSound("assets/sounds/death.whatever")	-- just a made up example
-- etc.

function SoundEngine.new(params)
	local newSoundEngine = {}
	
	setmetatable(newSoundEngine, SoundEngine)
	return newSoundEngine
end

function SoundEngine.playSound(nameOfSound)
	sounds[nameOfSound].play()
return SoundEngine

-- etc.