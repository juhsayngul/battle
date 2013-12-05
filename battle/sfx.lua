local sfx = {}  --create the main Sound Effects (sfx) table.

sfx.click = audio.loadSound( "audio/click.wav" )
sfx.badMove = audio.loadSound( "audio/invalid_move.aiff" )
sfx.attacked = audio.loadSound( "audio/unit_attacked.aiff" )
sfx.canAttack = audio.loadSound( "audio/cannon_attack.wav" )
sfx.canMove = audio.loadSound( "audio/cannon_move.wav" )
sfx.cavAttack = audio.loadSound( "audio/cavalry_attack.aiff" )
sfx.cavDeath = audio.loadSound( "audio/cavalry_death.wav" )
sfx.cavMove = audio.loadSound( "audio/cavalry_move.wav" )
sfx.heliMove = audio.loadSound( "audio/helicopter_move.wav" )
sfx.infAttack = audio.loadSound( "audio/infantry_attack.aiff" )
sfx.infDeath = audio.loadSound( "audio/infantry_death.wav" )
sfx.infMove = audio.loadSound( "audio/infantry_move.wav" )
sfx.machineAttack = audio.loadSound( "audio/machine_attack.wav" )
sfx.machineDeath = audio.loadSound( "audio/machine_death.aiff" )
sfx.tankAttack = audio.loadSound( "audio/tank_attack.wav" )
sfx.tankMove = audio.loadSound( "audio/tank_move.wav" )
-- sfx.bgm = audio.loadSound( "audio/bgm_loop.wav" )
-- sfx.menu = audio.loadSound( "audio/menu_loop.ogg" )
sfx.bgm = audio.loadSound( "audio/bgm_loop.mp3" )
sfx.menu = audio.loadSound( "audio/menu_loop.mp3" )

sfx.enabled = true

sfx.enable = function()
	audio.setVolume(1.0)
	sfx.enabled = true
end

sfx.disable = function()
	audio.setVolume(0.0)
	sfx.enabled = false
end

sfx.channels = {}
-- we can address specific channels pseudo-globally using this technique
-- look for what's done with sfx.channels.bgm as an example

sfx.playMoveSound = function(unitType)
	if (unitType == "infantry_f") or (unitType == "infantry_e") then
		audio.play(sfx.infMove)
		print("infantryMoving!")
	elseif (unitType == "tank_f") or (unitType == "tank_e") then
		audio.play(sfx.tankMove)
	else
		print("Nope!: "..unitType)
	end
end

return sfx