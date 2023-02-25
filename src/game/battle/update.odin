package battle


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/camera"
import "../../game/standee"
import "../../game/monsters"
import "../../game/settings"
import "../../game/standee/animations"


//= Constants
ARENA_MIN_X ::  8
ARENA_MAX_X :: 23
ARENA_MIN_Z :: 55.5
ARENA_MAX_Z :: 62.75

//= Procedures
update :: proc() {
	player	:= &game.battleStruct.playerPokemon
	enemy	:= &game.battleStruct.enemyPokemon
	pkmn	:=  game.battleStruct.playerPokemon.pokemonInfo
	
	//* Player Position
	upDown    := settings.is_key_down("up")
	downDown  := settings.is_key_down("down")
	leftDown  := settings.is_key_down("left")
	rightDown := settings.is_key_down("right")
	if upDown {
		player.position -= {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
		player.direction = .up
	} else if downDown {
		player.position += {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
		player.direction = .down
	}
	if leftDown {
		player.position -= {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)
		player.direction = .left
	} else if rightDown {
		player.position += {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)
		player.direction = .right
	}
	if !upDown && !downDown && !leftDown && !rightDown {
		dir := reflect.enum_string(player.direction)
		animations.set_animation(&player.standee.animator, strings.concatenate({"idle_", dir}))
	} else {
		dir := reflect.enum_string(player.direction)
		animations.set_animation(&player.standee.animator, strings.concatenate({"walk_", dir}))
	}
	if player.position.x > ARENA_MAX_X do player.position.x = ARENA_MAX_X
	if player.position.x < ARENA_MIN_X do player.position.x = ARENA_MIN_X
	if player.position.z > ARENA_MAX_Z do player.position.z = ARENA_MAX_Z
	if player.position.z < ARENA_MIN_Z do player.position.z = ARENA_MIN_Z


	//* Attack UI
	count	:= monsters.number_attacks(player.pokemonInfo.attacks)
	rot		:= 360 - game.battleStruct.playerAttackRot

	interval := f32(360 / count)
	if rot != (f32(player.selectedAtk) * interval) {
		if game.battleStruct.rotationDirect do game.battleStruct.playerAttackRot += 5
		else do game.battleStruct.playerAttackRot -= 5

		if game.battleStruct.playerAttackRot < 0 do game.battleStruct.playerAttackRot = 360
		if game.battleStruct.playerAttackRot > 360 do game.battleStruct.playerAttackRot = 0
	}

	if rot == (f32(player.selectedAtk) * interval) {
		if settings.is_key_down("switch_attack_left") {
			if player.selectedAtk == 0 do player.selectedAtk = count-1
			else do player.selectedAtk -= 1
			game.battleStruct.rotationDirect = true
		}
		if settings.is_key_down("switch_attack_right") {
			if player.selectedAtk == count-1 do player.selectedAtk = 0
			else do player.selectedAtk += 1
			game.battleStruct.rotationDirect = false
		}

		if settings.is_key_pressed("attack") {
			fmt.printf("fuck")
		}
	}
	


	//* Boundingbox calcs
	switch player.pokemonInfo.size {
		case .small:
			player.bounds = {
				{player.position.x, 0, player.position.z},
				{player.position.x + 1, +1, player.position.z + 1.25},
			}
		case .medium:
			player.bounds = {
				{player.position.x - 0.25, 0, player.position.z - 0.25},
				{player.position.x + 1.25, 1, player.position.z + 1.50},
			}
		case .large:
			player.bounds = {
				{player.position.x - 0.5, 0, player.position.z - 0.50},
				{player.position.x + 1.5, 1, player.position.z + 1.75},
			}
	}
	switch enemy.pokemonInfo.size {
		case .small:
			enemy.bounds = {
				{enemy.position.x, 0, enemy.position.z},
				{enemy.position.x + 1, +1, enemy.position.z + 1.25},
			}
		case .medium:
			enemy.bounds = {
				{enemy.position.x - 0.25, 0, enemy.position.z - 0.25},
				{enemy.position.x + 1.25, 1, enemy.position.z + 1.50},
			}
		case .large:
			enemy.bounds = {
				{enemy.position.x - 0.5, 0, enemy.position.z - 0.50},
				{enemy.position.x + 1.5, 1, enemy.position.z + 1.75},
			}
	}
	

	if settings.is_key_down("debug") {
		player.pokemonInfo.experience += 1
		game.battleStruct.playerAttackRot += 2
	}
}