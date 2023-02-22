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

	pokemon		: [4]Pokemon,
}

Entity :: struct {
	previous	: raylib.Vector3,
	position	: raylib.Vector3,
	target		: raylib.Vector3,

	visibleVar	: string,
	visible		: bool,

	id			: string,

	isMoving	: bool,
	isSurfing	: bool,

	direction	: Direction,

	standee		: ^Standee,

	interactionEvent : raylib.Vector2,
}

Event :: struct {
	position		: raylib.Vector3,
	interactable	: bool,

	visibleVar		: string,
	visible			: bool,

	chain : [dynamic]EventChain,
}
EventChain :: union {
	WarpEvent,
	TextEvent,
	TurnEvent,
	MoveEvent,
	WaitEvent,
	EmoteEvent,
	ConditionalEvent,
	SetConditionalEvent,
	SetTileEvent,
	GetPokemonEvent,
}
WarpEvent :: struct {
	entityid	: string,
	position	: raylib.Vector3,
	direction	: Direction,
	move		: bool,
}
TextEvent :: struct {
	text		: ^cstring,
}
MoveEvent :: struct {
	entityid	: string,
	direction	: Direction,
	times		: int,
	simul		: bool,
}
TurnEvent :: struct {
	entityid	: string,
	direction	: Direction,
}
WaitEvent :: struct {
	time : int,
}
EmoteEvent :: struct {
	entityid	: string,
	emote		: Emote,
	multiplier	: f32,
}
ConditionalEvent :: struct {
	variableName	: string,
	value			: bool,
	event			: raylib.Vector2,
}
SetConditionalEvent :: struct {
	variableName	: string,
	value			: bool,
}
SetTileEvent :: struct {
	position	: raylib.Vector2,
	value		: string,
	solid, surf	: bool,
}
GetPokemonEvent :: struct {
	species : PokemonSpecies,
	level	: int,
}

EmoteStruct :: struct {
	src, dest	: raylib.Rectangle,
	duration	: int,
	maxDuration : int,
	player		: bool,
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
	uses			:  int,

	eventVariables	: map[string]bool,
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

Pokemon :: struct {
	species : PokemonSpecies,

	evAtk, evDef, evSpAtk, evSpDef, evSpd : int,
	experience : int,

	attacks : [4]PokemonAttacks,
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

Emote :: enum {
	shocked,
	confused,
	sad,
}

PokemonSpecies :: enum {
	empty,

	chikorita,
	bayleef,
	meganium,

	cyndaquil,
	quilava,
	typhlosion,

	totodile,
	croconaw,
	feraligatr,
}

PokemonAttacks :: enum {
	empty,

	tackle,
	scratch,

	growl,
	leer,

	leafage,
	ember,
	watergun,
}