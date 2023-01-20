package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../over_char"


//= Procedure
init :: proc() {
	data = new(Player)

	data.camera.position   = {0.5, 7.5, 3}
	data.camera.target     = {0.5, 0.5, 0.5}
	data.camera.up         = {0, 1, 0}
	data.camera.fovy       = 70
	data.camera.projection = .PERSPECTIVE


	data.overworldCharacter.sprite = sprites.create("player_1")^
}