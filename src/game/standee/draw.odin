package standee


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc(
	standee : ^game.Standee,
) {
	raylib.DrawMesh(
		standee.mesh,
		standee.material,
		standee.position,
	)

	update_animations(standee)
}

update_animations :: proc(
	standee : ^game.Standee,
) {
	standee.animator.timer += 1

	animation := standee.animator.animations[standee.animator.currentAnimation]
	if standee.animator.timer > animation.animationSpeed {
		standee.animator.timer  = 0
		standee.animator.frame += 1

		if standee.animator.frame >= u32(len(animation.frames)) do standee.animator.frame = 0
	}
}