package game


//= Imports
import "vendor:raylib"


//= Globals
camera : ^Camera
player : ^Player


//= Structures
Camera :: struct {
	using data   :  raylib.Camera3D,
	targetEntity : ^Entity,
}

Player :: struct {
	entity    : ^Entity,
	moveTimer :  u8,
}

Entity :: struct {
	previous  : raylib.Vector3,
	position  : raylib.Vector3,
	target    : raylib.Vector3,

	isMoving  : bool,
	isSurfing : bool,

	direction : Direction,

	standee   : ^Standee,
}

Standee :: struct {
	animator : StandeeAnimation,

	mesh     : raylib.Mesh,
	material : raylib.Material,
	position : raylib.Matrix,
}

StandeeAnimation :: struct {
	rawImage : raylib.Image,

	currentAnimation : string,
	frame : u32,
	timer : u32,

	animations : map[string]Animation,
}

Animation :: struct {
	animationSpeed : u32,
	frames : [dynamic]u32,
}

Zone :: struct {}


//= Enumerations

Direction :: enum {
	up,
	down,
	left,
	right,
}