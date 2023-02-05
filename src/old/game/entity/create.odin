package entity


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../../graphics/standee"


//= Procedures
create :: proc(
	position : raylib.Vector3 = {0, 0, 0},
	filename : string,
) -> ^game.Entity {
	data := new(game.Entity)

	data.previous  = position
	data.position  = position
	data.target    = position

	data.isMoving  = false
	data.isSurfing = false

	data.direction = .down

	data.standee   = standee.create(filename)^

	return data
}