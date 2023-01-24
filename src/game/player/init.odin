package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../entity"
import "../../graphics/sprites"


//= Procedure
init :: proc() {
	data = new(Player)

	data.entity.position  = {13,0,6}
	data.entity.target    = {13,0,6}
	data.entity.direction = .down
	data.entity.sprite    = sprites.create("player_1")^

	data.moveTimer        = 0
}

close :: proc() {
	free(data)
}