package camera


//= Imports
import "vendor:raylib"

import "../../game"


//= Globals
data : ^Camera


//= Structures
Camera :: struct {
	using data : raylib.Camera3D,

	follow : ^game.Entity,
}