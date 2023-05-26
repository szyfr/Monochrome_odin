package game


//= Imports
import "vendor:raylib"


//= Structures
EventManager :: struct {
	currentEvent	: ^Event,
	textbox			:  Textbox,
	currentChain	:  int,
	uses			:  int,

	eventVariables	: map[string]union{ int, bool, string },
	
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

Event :: struct {
	id		: string,
	chain	: [dynamic]EventChain,
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
	GetMonsterEvent,
	StartBattleEvent,
	EndBattleEvent,
	PlaySoundEvent,
	PlayMusicEvent,
	OverlayAnimationEvent,
	ChoiceEvent,
	GiveExperience,
	ShowLevelUp,
	SkipEvent,
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
	skipwait	: bool,
}
ConditionalEvent :: struct {
	varName		: string,
	varValue	: union{ int, bool, string },
	eventType	: ConditionalType,
	eventData	: union{ int, raylib.Vector2, string },
}
SetConditionalEvent :: struct {
	variableName	: string,
	value			: union{ int, bool, string },
}
SetTileEvent :: struct {
	position	: raylib.Vector2,
	value		: string,
	solid, surf	: bool,
}
GetMonsterEvent :: struct {
	species : MonsterSpecies,
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
	event	: union{ int, string },
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
SkipEvent :: struct {
	event : int,
}


//= Enumerations
EventType :: enum {
	null,
	warp,
	trigger,
	interact,
}

ConditionalType :: enum {
	new_event,
	jump_chain,
	set_chain,
	leave_chain,
	start_battle,
}

TextboxState :: enum {
	inactive,
	active,
	finished,
	reset,
}