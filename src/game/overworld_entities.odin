package game


//= Imports
import "vendor:raylib"


//= Structures
Camera :: struct {
	using data   :  raylib.Camera3D,

	targetEntity : ^Entity,
}

Player :: struct {
	entity		: ^Entity,
	moveTimer	:  u8,
	canMove		:  bool,
	menu		:  MenuState,
	menuSel		:  u8,
	pokeSel		:  u8,

	monster		: [4]Monster,
}

Entity :: struct {
	previous	: raylib.Vector3,
	position	: raylib.Vector3,
	target		: raylib.Vector3,

	conditional : map[string]bool,

	id			: string,

	isMoving	: bool,
	isSurfing	: bool,

	direction	: Direction,

	standee		: ^Standee,

	interactionEvent : raylib.Vector2,
}

Standee :: struct {
	animator	: StandeeAnimation,

	mesh		: raylib.Mesh,
	material	: raylib.Material,
	position	: raylib.Matrix,
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

EmoteStruct :: struct {
	transform	:  raylib.Matrix,
	mesh		: ^raylib.Mesh,
	material	: ^raylib.Material,

	duration	: int,
}


//= Enumerations
Direction :: enum {
	up,
	down,
	left,
	right,
}

Emote :: enum {
	shocked,
	confused,
	sad,
	heart,
	happy,
	poison,
}