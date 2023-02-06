package entity


//= Imports
import "core:fmt"

import "../../game"
import "../../game/animations"
import "../../utilities/mathz"


//= Procedures
update :: proc(
	entity : ^game.Entity,
) {
	//* Update movement
	if entity.isMoving {
		//* Move
		entity.position.y = entity.target.y
		switch entity.direction {
			case .up:
				entity.position.z -= 0.04
				if entity.standee.animator.currentAnimation != "walk_up" do animations.set_animation(&entity.standee.animator, "walk_up")
			case .down:
				entity.position.z += 0.04
				if entity.standee.animator.currentAnimation != "walk_down" do animations.set_animation(&entity.standee.animator, "walk_down")
			case .left:
				entity.position.x -= 0.04
				if entity.standee.animator.currentAnimation != "walk_left" do animations.set_animation(&entity.standee.animator, "walk_left")
			case .right:
				entity.position.x += 0.04
				if entity.standee.animator.currentAnimation != "walk_right" do animations.set_animation(&entity.standee.animator, "walk_right")
		}


		//* Check if reached location
		if mathz.approximately(entity.position, entity.target) {
			entity.isMoving = false
			entity.position = entity.target
		}
	} else {
		switch entity.direction {
			case .up:    if entity.standee.animator.currentAnimation != "idle_up"    do animations.set_animation(&entity.standee.animator, "idle_up")
			case .down:  if entity.standee.animator.currentAnimation != "idle_down"  do animations.set_animation(&entity.standee.animator, "idle_down")
			case .left:  if entity.standee.animator.currentAnimation != "idle_left"  do animations.set_animation(&entity.standee.animator, "idle_left")
			case .right: if entity.standee.animator.currentAnimation != "idle_right" do animations.set_animation(&entity.standee.animator, "idle_right")
		}
	}
}