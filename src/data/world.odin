package data


//= Imports
import "vendor:raylib"


//= Structures
World :: struct {
	models : map[string]raylib.Model,

	currentMap : map[raylib.Vector3]Tile,
	unitMap    : map[string]^Unit,
}

Tile :: struct {
	model : string,

	solid  : [4]bool,
	water  : bool,
	trnsp  : bool,
}