package entity


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
update :: proc(entity : ^game.Entity) {
	if entity.isMoving {
		entity.position.y = entity.target.y
		switch entity.direction {
			case .up:
				entity.position.z -= 0.05
				play_animation(entity, "walk_up")
			case .down:
				entity.position.z += 0.05
				play_animation(entity, "walk_down")
			case .left:
				entity.position.x -= 0.05
				play_animation(entity, "walk_left")
			case .right:
				entity.position.x += 0.05
				play_animation(entity, "walk_right")
		}

		//* Check if target reached
		if approx(entity.position, entity.target) {
			entity.isMoving = false
			entity.position = entity.target
		}
	} else {
		switch entity.direction {
			case .up:		play_animation(entity, "idle_up")
			case .down:		play_animation(entity, "idle_down")
			case .left: 	play_animation(entity, "idle_left")
			case .right:	play_animation(entity, "idle_right")
		}
	}
}

approx :: proc(v1,v2 : raylib.Vector3) -> bool {
	threshhold : f32 = 0.05
	distX := v2.x - v1.x
	distY := v2.y - v1.y
	distZ := v2.z - v1.z

	if (distX > -threshhold && distX < threshhold) &&
		(distY > -threshhold && distY < threshhold) &&
		(distZ > -threshhold && distZ < threshhold) {
			return true
		} else do return false
}