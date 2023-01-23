package camera


//= Imports
import "vendor:raylib"


//= Procedures
move :: proc(
	newPos : raylib.Vector3,
) {
	data.target   = newPos + {0.5, 0.5, 0.5}
	data.position = newPos + {0.5, 7.5, 3}
}