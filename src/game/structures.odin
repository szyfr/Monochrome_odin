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
	using data		:  raylib.Camera3D,
	targetEntity	: ^Entity,
	zoom			:  f32,
}

Player :: struct {
	entity		: ^Entity,
	moveTimer	:  u8,
	canMove		:  bool,
	menu		:  MenuState,
	menuSel		:  u8,
	pokeSel		:  u8,

	monsters	: [4]Monster,
}

Entity :: struct {
	//* Position
	previous	: raylib.Vector3,
	position	: raylib.Vector3,
	target		: raylib.Vector3,

	//* NPC
	id			: string,
	events		: [dynamic]EntityEvent,
	//	conditional : map[string]bool,
	//	interactionEvent : raylib.Vector2,

	//* Conditions
	//TODO AI movement
	direction	: Direction,
	isMoving	: bool,
	isSurfing	: bool,

	//* Standee
	mesh		: ^raylib.Mesh,
	animator	:  Animator,
}

EntityEvent :: struct {
	conditions : map[string]union{ int, bool, string },
	id : string,
}

EmoteStruct :: struct {
	transform	:  raylib.Matrix,
	mesh		: ^raylib.Mesh,
	material	: ^raylib.Material,

	duration	: int,
}

Animator :: struct {
	material	: raylib.Material,
	textures	: [dynamic]raylib.Texture,

	currentAnimation	: string,
	animations			: map[string]Animation,
	frame				: u32,
	timer				: u32,
}

Animation :: struct {
	frames	: [dynamic]u32,
	speed	: u32,
}

Region :: struct {
	size		: raylib.Vector2,
	tiles		: map[raylib.Vector2]Tile,
	entities	: map[raylib.Vector2]Entity,
	triggers	: map[raylib.Vector2]string,
	battles		: map[string]BattleInfo,
	events		: map[string]Event,
	aniTimer	: int,
	frame		: int,
}

Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
	solid : bool,
	surf  : bool, 
}

AudioSystem :: struct {
	musicFilenames	: map[string]cstring,
	soundFilenames	: map[string]cstring,

	musicCurrentName: string,
	musicCurrent	: raylib.Music,

	soundCurrentName: string,
	soundCurrent	: raylib.Sound,
}


//= Enumerations
Direction :: enum {
	right,
	down,
	left,
	up,
}

Emote :: enum {
	shocked,
	confused,
	sad,
	heart,
	happy,
	poison,
}

MenuState :: enum {
	none,
	pause,
	pokedex,
	monster,
	bag,
	player,
	options,
}

Difficulty :: enum {
	easy,
	medium,
	hard
}