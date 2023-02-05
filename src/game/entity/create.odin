package entity


//= Imports
import "vendor:raylib"

import "../../game"
import "../../game/standee"


//= Procedures
create :: proc(
	filename : string,

	position : raylib.Vector3 = { 0, 0, 0 },
) -> ^game.Entity {
	data := new(game.Entity)

	data.previous  = position
	data.position  = position
	data.target    = position

	data.isMoving  = false
	data.isSurfing = false

	data.direction = .down

	data.standee   = standee.create(filename)

	return data
}