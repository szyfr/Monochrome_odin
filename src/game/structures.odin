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
	entity		: ^Entity,
	moveTimer	:  u8,
	canMove		:  bool,
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

Event :: struct {
	position : raylib.Vector3,
	interactable : bool,

	chain : [dynamic]EventChain,
}
EventChain :: union {
	raylib.Vector3,
	^cstring,
	//TODO
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
Region :: struct {
	size		: raylib.Vector2,
	tiles		: map[raylib.Vector2]Tile,
	entities	: map[raylib.Vector2]Entity,
	events		: map[raylib.Vector2]Event,
}

EventManager :: struct {
	currentEvent	: ^Event,
	textbox			:  Textbox,
	currentChain	:  int,
}
Textbox :: struct {
	state		: TextboxState,
	currentText	: string,
	targetText	: string,
	timer		: int,
	pause		: int,
	position	: int,
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

EventType :: enum {
	null,
	warp,
	trigger,
	interact,
}

TextboxState :: enum {
	inactive,
	active,
	finished,
	reset,
}