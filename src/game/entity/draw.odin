package entity


//= Imports
import "core:math/linalg"

import "vendor:raylib"

import "../../game"
import "../../game/standee"
import "../../utilities/mathz"


//= Procedures
draw :: proc(
	entity : ^game.Entity,
) {
	position : linalg.Matrix4x4f32 = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		entity.position.x, entity.position.y, entity.position.z, 1,
	}
	entity.standee.position = position
	standee.draw(entity.standee)
}