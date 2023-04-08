package entity


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc( entity : ^game.Entity ) {
	transform : raylib.Matrix = {
		1.00,  0.00, 0.00, 0.00,
		0.00,  0.78, 0.80, 0.00,
		0.00, -0.80, 0.78, 0.00,
		0.00,  0.00, 0.00, 1.00,
	}
	transform[3,0] = entity.position.x + 0.5
	transform[3,1] = entity.position.y + 0.5
	transform[3,2] = entity.position.z + 0.5

	raylib.DrawMesh(
		entity.mesh^,
		entity.animator.material,
		transform,
	)
}