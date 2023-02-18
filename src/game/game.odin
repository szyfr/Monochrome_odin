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
font			: raylib.Font

tiles			:  map[string]raylib.Model
region			: ^Region
localization	:  map[string]cstring
eventmanager	: ^EventManager