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
	menu		:  MenuState,
	menuSel		:  u8,
	pokeSel		:  u8,

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
	EndBattleEvent,
	PlaySoundEvent,
	PlayMusicEvent,
	OverlayAnimationEvent,
	ChoiceEvent,
	GiveExperience,
	ShowLevelUp,
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
	id	: string,
}
EndBattleEvent :: struct {
	welp : bool,
}
PlaySoundEvent :: struct {
	name	: string,
	pitch	: f32,
}
PlayMusicEvent :: struct {
	name	: string,
	pitch	: f32,
}
OverlayAnimationEvent :: struct {
	texture			: raylib.Texture,
	length			: int,
	timer			: int,
	animation		: [dynamic]int,
	stay			: bool,

	currentFrame	: int,
}
ChoiceEvent :: struct {
	text	: ^cstring,
	choices	: [dynamic]Choice,
}
Choice :: struct {
	text	: ^cstring,
	event	: raylib.Vector2,
}
GiveExperience :: struct {
	amount : int,
	member : int,
}
ShowLevelUp :: struct {
	level	: int,
	hp		: int,
	atk		: int,
	def		: int,
	spatk	: int,
	spdef	: int,
	spd		: int,
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
	aniTimer	: int,
	frame		: int,
}

EventManager :: struct {
	currentEvent	: ^Event,
	textbox			:  Textbox,
	currentChain	:  int,
	uses			:  int,

	eventVariables	: map[string]bool,
	playerName		: string,
	playerPronouns	: [3]string,
	rivalName		: string,
}
Textbox :: struct {
	state		: TextboxState,
	currentText	: string,
	targetText	: string,
	timer		: int,
	pause		: int,
	position	: int,
	
	hasChoice	: bool,
	choiceList	: [dynamic]Choice,
	curPosition	: int,
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
	elementalType1	: ElementalType,
	elementalType2	: ElementalType,

	nickname: cstring,

	iv		: [6]int,
	ev		: [6]int,

	hpMax	: int,
	hpCur	: int,

	atk		: int,
	def		: int,
	spAtk	: int,
	spDef	: int,
	spd		: int,
	
	statChanges : [6]int,

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
	enemyPokemonList: [4]^Pokemon,
	enemyName		: string,

	experience		: int,

	playerHPBar		: raylib.Texture,
	playerEXPBar	: raylib.Texture,
	enemyHPBar		: raylib.Texture,
	playerAttackRot	: f32,
	rotationDirect	: bool,

	attackEntities	: [dynamic]AttackEntity,

	playerTarget	: raylib.Vector3,
	enemyTarget		: raylib.Vector3,
}
BattleEntity :: struct {
	position	: raylib.Vector3,
	isMoving	: bool,
	canMove		: bool,
	timer		: int,
	direction	: Direction,
	bounds		: raylib.BoundingBox,
	selectedAtk	: int,

	wild		: bool,

	forcedMove			: bool,
	forcedMoveTarget	: raylib.Vector3,
	forcedMoveStart		: raylib.Vector3,

	standee		: ^Standee,

	pokemonInfo	: ^Pokemon,
}

AttackEntity :: union {
	AttackFollow,
}
AttackFollow :: struct {
	attackModel : string,
	target	: ^BattleEntity,
	bounds	: raylib.BoundingBox,
	boundsSize : raylib.Vector3,
	sphere: bool,

	attackType		: AttackType,
	elementalType	: ElementalType,
	power			: f32,
	effects			: [dynamic]AttackEffect,

	life	: int,
	user	: ^Pokemon,
	player	: bool,
}

AttackOverlay :: union {
	AttackOverlayGeneral,
}
AttackOverlayGeneral :: struct {
	origin	: raylib.Vector3,
	mesh	: raylib.Mesh,
	model	: raylib.Model,
	texture	: raylib.Texture,
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
AttackType :: enum {
	physical,
	special,
	other,
}
ElementalType :: enum {
	none,
	normal,
	water,
	fire,
	grass,
}

AttackEffect :: enum {
	atkDown_enemy,
	atkDown_self,
	defDown_enemy,
	defDown_self,
	spatkDown_enemy,
	spatkDown_self,
	spdefDown_enemy,
	spdefDown_self,
	spdDown_enemy,
	spdDown_self,
	
	atkUp_enemy,
	atkUp_self,
	defUp_enemy,
	defUp_self,
	spatkUp_enemy,
	spatkUp_self,
	spdefUp_enemy,
	spdefUp_self,
	spdUp_enemy,
	spdUp_self,
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

MenuState :: enum {
	none,
	pause,
	pokedex,
	pokemon,
	bag,
	player,
	options,
}