package over_char


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../camera"
import "../../graphics/sprites"


//= Procedures
draw :: proc(
	char : ^OverworldCharacter,
) {
	sprites.draw(camera.data, &char.sprite)
}