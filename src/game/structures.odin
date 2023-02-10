package game


//= Imports
import "vendor:raylib"


//= Globals


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

Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
	solid : bool,
	surf  : bool, 
}

Zone :: struct {
	name      : string,

	width     : f32,
	height    : f32,

	position  : raylib.Vector3,

	outskirts : string,

	tiles     : [dynamic][dynamic]Tile,
	entities  : [dynamic]Entity,
}

Options :: struct {
	//TODO Keybindings
	screenWidth  : i32,
	screenHeight : i32,

	textSpeed    : i32,
	fpsLimit     : i32,

	language     : string,
}


//= Enumerations

Direction :: enum {
	up,
	down,
	left,
	right,
}