package player


//= Imports
import "vendor:raylib"

import "../entity"


//= Globals
data : ^Player


//= Structures
Player :: struct {
	entity    : entity.Entity,
	moveTimer : u8,
}