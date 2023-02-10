package game


//= Imports
import "vendor:raylib"


//= Constants
LIMIT_FPS :: true
DRAW_MAP  :: true


//= Globals
running : bool = true

camera  : ^Camera
player  : ^Player
options : ^Options

tiles        : map[string]raylib.Model
zones        : map[string]Zone
localization : map[string]cstring