package battle


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../../game/camera"
import "../../game/standee"


//= Constants
ARENA_MIN_X ::  8
ARENA_MAX_X :: 23
ARENA_MIN_Z :: 55.5
ARENA_MAX_Z :: 62.75

//= Procedures
update :: proc() {
	player	:= &game.battleStruct.playerPokemon
	pkmn	:=  game.battleStruct.playerPokemon.pokemonInfo

	if raylib.IsKeyDown(.W) do player.position -= {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
	if raylib.IsKeyDown(.S) do player.position += {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
	if raylib.IsKeyDown(.A) do player.position -= {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)
	if raylib.IsKeyDown(.D) do player.position += {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)

	if player.position.x > ARENA_MAX_X do player.position.x = ARENA_MAX_X
	if player.position.x < ARENA_MIN_X do player.position.x = ARENA_MIN_X
	if player.position.z > ARENA_MAX_Z do player.position.z = ARENA_MAX_Z
	if player.position.z < ARENA_MIN_Z do player.position.z = ARENA_MIN_Z

	if raylib.IsKeyPressed(.K) do close()
}