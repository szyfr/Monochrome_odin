package unit


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../data"
import "../graphics"


//= Procedures
draw :: proc( unit : ^data.Unit) {
	//* Animation update
	animation := graphics.animations[unit.animator.currentAnimation]

	unit.animator.counter += 1
	if animation.delay != 0 && unit.animator.counter >= animation.delay {
		unit.animator.counter = 0
		unit.animator.frame += 1
		if unit.animator.frame >= len(animation.frames) do unit.animator.frame = 0
	}
	unit.animator.material.maps[0].texture = unit.animator.textures[animation.frames[unit.animator.frame]]

	//* Create matrix and draw
	mat : raylib.Matrix = {
		math.cos(data.cameraData.rotation / 57.3),0,math.sin(data.cameraData.rotation / 57.3),0,
		0,1,0,0,
		-math.sin(data.cameraData.rotation / 57.3),0,math.cos(data.cameraData.rotation / 57.3),0,
		unit.position.x,unit.position.y,unit.position.z,1,
	}
	raylib.DrawMesh(
		unit.animator.mesh,
		unit.animator.material,
		mat,
	)
}

set_animation :: proc( anim : string, unit : ^data.Unit ) {
	if unit.animator.currentAnimation != anim {
		unit.animator.frame = 0
		unit.animator.counter = 0
		unit.animator.currentAnimation = anim
	}
}