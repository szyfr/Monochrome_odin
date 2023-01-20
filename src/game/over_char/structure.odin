package over_char


//= Imports
import "vendor:raylib"

import "../../graphics/sprites"


//= Structures
OverworldCharacter :: struct {
	currentPosition : raylib.Vector3,
	nextPosition    : raylib.Vector3,
	isMoving        : bool,

	sprite : sprites.Sprite,

	direction : Direction,
}

Direction :: enum {
	up,
	down,
	left,
	right,
}