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
	location : EventTarget,
	type     : EventType,
	data     : EventData,
}
EventTarget :: union {
	raylib.Vector2,
	Entity,
}
EventData :: union {
	raylib.Vector2,		//Warp
	[dynamic]string,	//Text
	[dynamic]EventChain,//Chain
	//TODO Story changes
	//TODO Quests
}
EventChain :: struct {}
EventHandler :: struct {
	currentMap	: ^Zone,
	player		: ^Player,
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

Zone :: struct {
	name      : string,

	width     : f32,
	height    : f32,

	position  : raylib.Vector3,

	outskirts : string,

	tiles     : [dynamic][dynamic]Tile,
	entities  : [dynamic]Entity,
	events    : map[raylib.Vector2]Event,
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