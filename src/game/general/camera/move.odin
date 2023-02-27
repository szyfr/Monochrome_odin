package camera


//= Imports
import "vendor:raylib"

import "../../../game"


//= Procedures
move :: proc(
	position	: raylib.Vector3,
	zoom		: f32,
) {
	if game.camera.targetEntity != nil do game.camera.targetEntity = nil
	game.camera.target		= position
	game.camera.position	= position + ({0.0, 7.0, 2.5} * zoom)
}

attach_to_player :: proc() {
	game.camera.targetEntity = game.player.entity
}