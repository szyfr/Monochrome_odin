package game


//= Imports
import  "core:fmt"
import  "core:encoding/json"

import "vendor:raylib"


//= Constants
LIMIT_FPS :: true
DRAW_MAP  :: true


//= Globals
running		: bool = true

camera		: ^Camera
player		: ^Player


//* Settings
screenWidth		: i32
screenHeight	: i32
textSpeed		: i32
fpsLimit		: i32
language		: string
masterVolume	: f32
musicVolume		: f32
soundVolume		: f32
keybindings		: map[string]Keybinding


//* Graphics
box_ui			: raylib.Texture
box_ui_npatch	: raylib.NPatchInfo
pokemon_info_ui	: raylib.Texture
typeTexture		: raylib.Texture
pointer			: raylib.Texture
barHP			: raylib.Texture
barEXP			: raylib.Texture
barImg			: raylib.Image

font			: raylib.Font

pokemonSprites	: map[MonsterSpecies]raylib.Texture

//* Targeter
targeter		: raylib.Model
attackOverlays	: map[PokemonAttack]AttackOverlay

indicator		: raylib.Material

overlayActive		: bool
overlayTexture		: raylib.Texture
overlayRectangle	: raylib.Rectangle


//* Audio
audio : ^AudioSystem


//* Data
tilesTest		:  map[string]raylib.Mesh
tilesMaterial	:  raylib.Material
tilesTexture	:  [8]raylib.Texture

tiles			:  map[string]raylib.Model
attackModels	:  map[string]raylib.Model
region			: ^Region
localization	:  map[string]cstring
eventmanager	: ^EventManager
battles			:  map[string]BattleData
battleStruct	: ^BattleStructure
lastBattleOutcome : bool = false
pokemonData		: json.Array

//* Emotes
emotes			: raylib.Image
emoteList		: [dynamic]EmoteStruct
emoteMaterials	: [8]raylib.Material
emoteMeshDef	: raylib.Mesh

battleTrainerWinEvent	: Event
battleWildWinEvent		: Event
battleTrainerLoseEvent	: Event
battleWildLoseEvent		: Event
levelUpDisplay : ^ShowLevelUp


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
	if event.varName != "" {
		var, res := eventmanager.eventVariables[event.varName]
		fmt.printf("%v:%v=%v",var,event.varValue,res && var == event.varValue)
		if res && var == event.varValue do return true
		else do return false
	} else {
		return true
	}
}