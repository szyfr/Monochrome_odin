package over_char


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../player"
import "../../graphics/sprites"


//= Procedures
draw :: proc(
	char : ^OverworldCharacter,
) {
	sprites.draw(player.camera, char.sprite)
}