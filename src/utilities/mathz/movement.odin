package mathz


//= Imports
import "vendor:raylib"


//= Constants
MODIFIER :: 0.1


//= Procedures
move_entity :: proc(
	previous : raylib.Vector3,
	current  : raylib.Vector3,
	target   : raylib.Vector3,
) -> raylib.Vector3 {

	modifier := (target - previous) * MODIFIER
	return current + modifier
	
}