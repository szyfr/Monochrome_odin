package tiles


//= Import
import "vendor:raylib"


//= Globals
data : map[string]raylib.Model


//= Structures
Tile :: struct {
	//model : ^raylib.Model,
	model : string,
	level : f32,
	solid : bool,
	surf  : bool, 
}