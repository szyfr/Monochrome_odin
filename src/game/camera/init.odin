package camera


//= Imports
import "vendor:raylib"


//= Procedures
init :: proc() {
	data.position   = {0.5, 7.5, 3}
	data.target     = {0.5, 0.5, 0.5}
	data.up         = {0, 1, 0}
	data.fovy       = 70
	data.projection = .PERSPECTIVE
}