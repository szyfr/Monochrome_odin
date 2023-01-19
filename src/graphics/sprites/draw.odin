package sprites


//= Imports
import "core:fmt"

import "vendor:raylib"

import "animations"


//= Procedures
draw :: proc(
	camera : raylib.Camera3D,
	sprite : ^Sprite,
) {
	frameX := f32(sprite.animator.animations[sprite.animator.currentAnimation].frames[sprite.animator.frame])
	rect : raylib.Rectangle = {
		frameX * sprite.size.x,
		0,
		sprite.size.x,
		sprite.size.y,
	}

	raylib.DrawBillboardPro(
		camera,
		sprite.texture,
		rect,
		camera.target,
		{0,0.9,-0.65},
		{1,1},
		{0,0},
		0,
		raylib.WHITE,
	)

	sprite.animator.timer += 1

	if sprite.animator.timer >= sprite.animator.animations[sprite.animator.currentAnimation].animationSpeed {
		sprite.animator.timer  = 0
		sprite.animator.frame += 1

		if sprite.animator.frame >= u32(len(sprite.animator.animations[sprite.animator.currentAnimation].frames)) {
			sprite.animator.frame = 0
		}
	}
}