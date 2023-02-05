package zone


//= Imports
import "vendor:raylib"

import "../../game"
import "../tiles"


//= Globals
zones : map[string]Zone


//= Structures
Zone :: struct {
	name      : string,

	width     : f32,
	height    : f32,

	position  : raylib.Vector3,

	outskirts : string,

	tiles     : [dynamic][dynamic]tiles.Tile,
	entities  : [dynamic]game.Entity,
}