package player


//= Imports
import "vendor:raylib"

import "../over_char"


//= Globals
data : ^Player


//= Structures
Player :: struct {
	overworldCharacter : over_char.OverworldCharacter,
	moveTimer : u8,
}