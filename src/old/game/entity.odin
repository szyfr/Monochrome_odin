package game


//= Imports
import "vendor:raylib"

import "../graphics/sprites"
import "../graphics/standee"


//= Structures
Entity :: struct {
	previous  : raylib.Vector3,
	position  : raylib.Vector3,
	target    : raylib.Vector3,

	isMoving  : bool,
	isSurfing : bool,

	direction : Direction,

	sprite    : sprites.Sprite,
	standee   : standee.Standee,
}

Direction :: enum {
	up,
	down,
	left,
	right,
}