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
	//position : linalg.Matrix4x4f32 = {
	//	1,0,0,0,
	//	0,1,0,0,
	//	0,0,1,0,
	//	entity.position.x,entity.position.y,entity.position.z,1,
	//}
	//entity.standee.position = mathz.mat_mult(entity.standee.position, position)
	entity.standee.position[3,0] = entity.position.x + 0.5
	entity.standee.position[3,1] = entity.position.y + 0.5
	entity.standee.position[3,2] = entity.position.z + 0.5
	standee.draw(entity.standee)
}