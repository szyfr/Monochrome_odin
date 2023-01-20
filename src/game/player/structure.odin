package player


//= Imports
import "vendor:raylib"

import "../over_char"


//= Globals
data : ^Player


//= Structures
Player :: struct {
	camera : raylib.Camera3D,
	overworldCharacter : over_char.OverworldCharacter,
}