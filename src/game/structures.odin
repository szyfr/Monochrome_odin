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
	StartBattleEvent,
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
StartBattleEvent :: struct {
	id			: string,
}

BattleData :: struct {
	id				: string,
	trainerName		: string,
	arena			: Arena,
	pokemonNormal	: [4]Pokemon,
	pokemonHard		: [4]Pokemon,
}

EmoteStruct :: struct {
	src, dest	: raylib.Rectangle,
	duration	: int,
	maxDuration : int,
	player		: bool,
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

Settings :: struct {
	screenWidth		: i32,
	screenHeight	: i32,

	textSpeed		: i32,
	fpsLimit		: i32,

	language		: string,

	keybindings		: map[string]Keybinding,
}
Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
}

Pokemon :: struct {
	species : PokemonSpecies,

	iv : [6]int,
	ev : [6]int,

	hpMax	: int,
	hpCur	: int,

	atk		: int,
	def		: int,
	spAtk	: int,
	spDef	: int,
	spd		: int,

	size	: Size,

	experience	: int,
	level		: int,
	//TODO Nature

	attacks : [4]Attack,
}
Attack :: struct {
	type : PokemonAttack,
	cooldown : int,
}

BattleStructure :: struct {
	arena		: Arena,

	playerPokemon	: BattleEntity,
	enemyPokemon	: BattleEntity,
	enemyPokemonList: [4]Pokemon,

	playerHPBar		: raylib.Texture,
	playerEXPBar	: raylib.Texture,
	enemyHPBar		: raylib.Texture,
	playerAttackRot	: f32,
	rotationDirect	: bool,

	playerTarget	: raylib.Vector3,
	enemyTarget		: raylib.Vector3,
}
BattleEntity :: struct {
	position	: raylib.Vector3,
	isMoving	: bool,
	canMove		: bool,
	direction	: Direction,
	bounds		: raylib.BoundingBox,
	selectedAtk	: int,

	standee		: ^Standee,

	pokemonInfo	: ^Pokemon,
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

PokemonAttack :: enum {
	empty,

	tackle,
	scratch,

	growl,
	leer,

	leafage,
	ember,
	watergun,
}

Size :: enum {
	small,
	medium,
	large,
}

Arena :: enum {
	empty,
	grass,
	forest,
	building,
	city,
	beach,
	water,
}