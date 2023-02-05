package tiles


//= Import
import "vendor:raylib"


//= Globals
data : map[string]raylib.Model


//= Structures
Tile :: struct {
	model : string,
	pos   : raylib.Vector3,
	solid : bool,
	surf  : bool, 
}