package battle


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/camera"
import "../../game/standee"
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
	pkmn	:=  game.battleStruct.playerPokemon.pokemonInfo
	
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

	if settings.is_key_pressed("debug") {
		player.pokemonInfo.experience += 1
	}
}