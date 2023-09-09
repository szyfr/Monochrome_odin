package camera


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
init :: proc() {
	game.camera = new(game.Camera)

	game.camera.position	= { 0.5, 7.5, 3.0 }
	game.camera.target		= { 0.5, 0.5, 0.5 }
	game.camera.up			= { 0.0, 1.0, 0.0 }
	game.camera.fovy		= 70
	game.camera.projection  = .PERSPECTIVE
	game.camera.zoom		= 1
}

close :: proc() {
	free(game.camera)
}