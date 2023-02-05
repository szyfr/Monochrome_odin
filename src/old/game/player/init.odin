package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../entity"
import "../../graphics/sprites"


//= Procedure
init :: proc() {
	data = new(Player)

	data.entity = entity.create(raylib.Vector3{13, 0, 6}, "player_1")^

	data.moveTimer = 0
}

close :: proc() {
	free(data)
}