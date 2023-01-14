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
	//outskirts : ^raylib.Model,
	outskirts : string,
	tiles     : [dynamic]tiles.Tile,
}