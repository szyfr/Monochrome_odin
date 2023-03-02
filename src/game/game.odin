package game


//= Imports
import  "core:encoding/json"

import "vendor:raylib"


//= Constants
LIMIT_FPS :: true
DRAW_MAP  :: true


//= Globals
running : bool = true

camera		: ^Camera
player		: ^Player


//* Settings
screenWidth		: i32
screenHeight	: i32
textSpeed		: i32
fpsLimit		: i32

language		: string

masterVolume	: f32

keybindings		: map[string]Keybinding


//* Graphics
box_ui			: raylib.Texture2D
box_ui_npatch	: raylib.NPatchInfo
emotes			: raylib.Texture2D
targeter		: raylib.Model
font			: raylib.Font
attackOverlays	: map[PokemonAttack]AttackOverlay


//* Audio
currentTrack	: string
music			: map[string]raylib.Sound


//* Data
tilesTest		:  map[string]raylib.Mesh
tilesMaterial	:  raylib.Material
tilesTexture	:  [8]raylib.Texture

tiles			:  map[string]raylib.Model
region			: ^Region
emoteList		: [dynamic]EmoteStruct
localization	:  map[string]cstring
eventmanager	: ^EventManager
battles			:  map[string]BattleData
battleStruct	: ^BattleStructure
lastBattleOutcome : bool = false
pokemonData		: json.Array


//= Procedures
check_variable :: proc{
	check_variable_simple,
	check_variable_conditionalevent,
}
check_variable_simple :: proc(
	name : string,
	value : bool,
) -> bool {
	if name != "" {
		var, res := eventmanager.eventVariables[name]
		if res && var != value do return true
		else do return false
	} else {
		return true
	}
}
check_variable_conditionalevent :: proc(
	event : ConditionalEvent,
) -> bool {
	if event.variableName != "" {
		var, res := eventmanager.eventVariables[event.variableName]
		if res && var == event.value do return true
		else do return false
	} else {
		return true
	}
}