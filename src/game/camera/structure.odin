package camera


//= Imports
import "vendor:raylib"

import "../entity"


//= Globals
data : ^Camera


//= Structures
Camera :: struct {
	using data : raylib.Camera3D,

	follow : ^entity.Entity,
}