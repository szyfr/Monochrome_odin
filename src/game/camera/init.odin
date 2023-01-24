package camera


//= Imports
import "vendor:raylib"

import "../player"


//= Procedures

init :: proc() {
	data = new(Camera)

	data.position   = {0.5, 7.5, 3}
	data.target     = {0.5, 0.5, 0.5}
	data.up         = {0, 1, 0}
	data.fovy       = 70
	data.projection = .PERSPECTIVE

	data.follow     = &player.data.entity
}

close :: proc() {
	free(data)
}