local sfx = {}  --create the main Sound Effects (sfx) table.

sfx.click = audio.loadSound( "assets/audio/click.wav" )
sfx.badMove = audio.loadSound( "assets/audio/invalid_move.aiff" )
-- sfx.attacked = audio.loadSound( "assets/audio/unit_attacked.aiff" )
sfx.canAttack = audio.loadSound( "assets/audio/cannon_attack.wav" )
sfx.canMove = audio.loadSound( "assets/audio/cannon_move.wav" )
sfx.cavAttack = audio.loadSound( "assets/audio/cavalry_attack.aiff" )
sfx.cavDeath = audio.loadSound( "assets/audio/cavalry_death.wav" )
sfx.cavMove = audio.loadSound( "assets/audio/cavalry_move.wav" )
sfx.heliMove = audio.loadSound( "assets/audio/helicopter_move.wav" )
sfx.infAttack = audio.loadSound( "assets/audio/infantry_attack.wav" )
sfx.infDeath = audio.loadSound( "assets/audio/infantry_death.wav" )
sfx.infMove = audio.loadSound( "assets/audio/infantry_move.wav" )
-- sfx.machineAttack = audio.loadSound( "assets/audio/machine_attack.wav" )
sfx.machineDeath = audio.loadSound( "assets/audio/machine_death.aiff" )
sfx.tankAttack = audio.loadSound( "assets/audio/tank_attack.wav" )
sfx.tankMove = audio.loadSound( "assets/audio/tank_move.wav" )

sfx.bgm = audio.loadSound( "assets/audio/bgm_loop.mp3" )
sfx.menu = audio.loadSound( "assets/audio/menu_loop.mp3" )

sfx.volume = {}
sfx.volume.FULL = 1.0
sfx.volume.LOUD = 0.75
sfx.volume.MEDIUM = 0.5
sfx.volume.QUIET = 0.25
sfx.volume.OFF = 0.0

sfx.channels = {}
-- we can address specific channels pseudo-globally using this technique
-- look for what's done with sfx.channels.bgm as an example

sfx.playMoveSound = function(unitType)
	if (unitType == "infantry_f") or (unitType == "infantry_e") then
		audio.play(sfx.infMove)
	elseif (unitType == "tank_f") or (unitType == "tank_e") then
		audio.play(sfx.tankMove)
	elseif (unitType == "heli_f") or (unitType == "heli_e") then
		audio.play(sfx.heliMove)
	elseif (unitType == "cannon_f") or (unitType == "cannon_e") then
		audio.play(sfx.canMove)
	elseif (unitType == "cavalry_f") or (unitType == "cavalry_e") then
		audio.play(sfx.cavMove)
	end
end

sfx.playAttSound = function(unitType)
	if (unitType == "infantry_f") or (unitType == "infantry_e") then
		audio.play(sfx.infAttack)
	elseif (unitType == "m") or (unitType == "tank_e") then
		audio.play(sfx.tankAttack)
	elseif (unitType == "heli_f") or (unitType == "heli_e") then
		audio.play(sfx.infAttack)
	elseif (unitType == "cannon_f") or (unitType == "cannon_e") then
		audio.play(sfx.canAttack)
	elseif (unitType == "cavalry_f") or (unitType == "cavalry_e") then
		audio.play(sfx.cavAttack)
	end
end

sfx.playDeathSound = function(unitType)
	if (unitType == "infantry_f") or (unitType == "infantry_e") then
		audio.play(sfx.infDeath)
	elseif (unitType == "tank_f") or (unitType == "tank_e") then
		audio.play(sfx.machineDeath)
	elseif (unitType == "heli_f") or (unitType == "heli_e") then
		audio.play(sfx.machineDeath)
	elseif (unitType == "cannon_f") or (unitType == "cannon_e") then
		audio.play(sfx.machineDeath)
	elseif (unitType == "cavalry_f") or (unitType == "cavalry_e") then
		audio.play(sfx.cavDeath)
	end
end

return sfx