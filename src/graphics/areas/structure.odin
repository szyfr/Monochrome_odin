package areas


//= Imports
import "vendor:raylib"

import "../tiles"


//= Globals
areas : map[string]AreaMap


//= Structures
AreaMap :: struct {
	name      : string,
	width     : f32,
	height    : f32,
	position  : raylib.Vector3,
	outskirts : string,
	tilesls  : [dynamic][dynamic]tiles.Tile,
}