package data


//= Imports
import "vendor:raylib"


//= Structures
World :: struct {
	models : map[string]raylib.Model,

	currentMap : map[raylib.Vector3]Tile,
}

Tile :: struct {
	model : string,

	solid  : [4]bool,
	offset : f32,
	ramp   : bool,
	water  : bool,
	trnsp  : bool,
}