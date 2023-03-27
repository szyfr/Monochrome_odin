package game


//= Imports
import "vendor:raylib"


//= Structures
Event :: struct {
	position		: raylib.Vector3,
	interactable	: bool,

	conditional		: map[string]bool,

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
	variableName	: string,
	value			: bool,
	event			: union{ int, raylib.Vector2, string },
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
	event	: union{ int, raylib.Vector2 },
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