package data


//= Imports
import "vendor:raylib"


//= Structures
Tile :: struct {
	model : string,

	solid : bool,
	water : bool,
	trnsp : bool,
}