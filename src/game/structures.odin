package game


//= Imports
import "vendor:raylib"


//= Structures
Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
}

Camera :: struct {
	using data   :  raylib.Camera3D,
	targetEntity : ^Entity,
}

Player :: struct {
	entity		: ^Entity,
	moveTimer	:  u8,
	canMove		:  bool,
//	menu		:  MenuState,
	menuSel		:  u8,
	pokeSel		:  u8,

//	monster		: [4]Monster,
}

Entity :: struct {
	//* Position
	previous	: raylib.Vector3,
	position	: raylib.Vector3,
	target		: raylib.Vector3,

	//* NPC
	id			: string,
	conditional : map[string]bool,
	interactionEvent : raylib.Vector2,

	//* Conditions
	//TODO AI movement
	direction	: Direction,
	isMoving	: bool,
	isSurfing	: bool,

	//* Standee
	mesh		: ^raylib.Mesh,
	animator	:  Animator,
}

Animator :: struct {
	material	: raylib.Material,
	textures	: [dynamic]raylib.Texture,

	currentAnimation	: string
	animations			: map[string]Animation,
	frame				: u32,
	timer				: u32,
}

Animation :: struct {
	animationSpeed : u32,
	frames	: [dynamic]u32,
}

Region :: struct {
	size		: raylib.Vector2,
	tiles		: map[raylib.Vector2]Tile,
	entities	: map[raylib.Vector2]Entity,
//	events		: map[raylib.Vector2]Event,
	aniTimer	: int,
	frame		: int,
}

Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
	solid : bool,
	surf  : bool, 
}


//= Enumerations
Direction :: enum {
	up,
	down,
	left,
	right,
}