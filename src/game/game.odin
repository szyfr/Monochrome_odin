package game


//= Imports
import "vendor:raylib"


//= Constants
LIMIT_FPS :: true
DRAW_MAP  :: true


//= Globals
running : bool = true

camera	: ^Camera
player	: ^Player
options	: ^Options

//* Graphics
box_ui			: raylib.Texture2D
box_ui_npatch	: raylib.NPatchInfo
emotes			: raylib.Texture2D
font			: raylib.Font

emoteList		: [dynamic]EmoteStruct

tiles			:  map[string]raylib.Model
region			: ^Region
localization	:  map[string]cstring
eventmanager	: ^EventManager
battles			:  map[string]BattleData
battleStruct	: ^BattleStructure
lastBattleOutcome : bool = false


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