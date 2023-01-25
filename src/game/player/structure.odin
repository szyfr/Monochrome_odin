package player


//= Imports
import "vendor:raylib"

import "../../game"


//= Globals
data : ^Player


//= Structures
Player :: struct {
	entity    : game.Entity,
	moveTimer : u8,
}