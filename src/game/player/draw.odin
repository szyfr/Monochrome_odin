package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../over_char"


//= Procedure
draw :: proc() {
	over_char.draw(&data.overworldCharacter)
}