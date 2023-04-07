package standee


//= Imports
import "vendor:raylib"

import "../../../game"


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

	//* Reset texture
	if len(standee.animator.animations[standee.animator.currentAnimation].frames) >= 1 {
		raylib.UnloadTexture(standee.material.maps[0].texture)
		posX  := standee.animator.animations[standee.animator.currentAnimation].frames[standee.animator.frame]
		frame := raylib.ImageFromImage(
			standee.animator.rawImage,
			{
				f32(standee.animator.rawImage.height * i32(posX)),
				0,
				f32(standee.animator.rawImage.height),
				f32(standee.animator.rawImage.height),
			},
		)
		standee.material.maps[0].texture = raylib.LoadTextureFromImage(frame)
		raylib.UnloadImage(frame)
	}
}