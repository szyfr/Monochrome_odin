package game


//= Imports
import "vendor:raylib"


//= Structures
Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
	solid : bool,
	surf  : bool, 
}

Region :: struct {
	size		: raylib.Vector2,
	tiles		: map[raylib.Vector2]Tile,
	entities	: map[raylib.Vector2]Entity,
	events		: map[raylib.Vector2]Event,
	aniTimer	: int,
	frame		: int,
}