package standee


//= Imports
import "vendor:raylib"


//= Procedures
draw :: proc(
	standee : ^Standee,
) {
	raylib.DrawMesh(
		standee.mesh,
		standee.material,
		standee.position,
	)
}