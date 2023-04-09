package entity


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc( entity : ^game.Entity ) {
	//* Draw mesh with material
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

	//* Update animations
	entity.animator.timer += 1
	curAni := &entity.animator.animations[entity.animator.currentAnimation]
	if entity.animator.timer >= curAni.animationSpeed {
		entity.animator.timer = 0
		entity.animator.frame += 1
		if entity.animator.frame >= u32(len(curAni.frames)) do entity.animator.frame = 0

		entity.animator.material.maps[0].texture = entity.animator.textures[curAni.frames[entity.animator.frame]]
	}
}