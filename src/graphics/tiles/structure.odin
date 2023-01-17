package tiles


//= Import
import "vendor:raylib"


//= Globals
data : map[string]raylib.Model


//= Structures
Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
//	level : f32,
	solid : bool,
	surf  : bool, 
}