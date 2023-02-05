package entity


//= Imports
import "../../game"
import "../../graphics/sprites/animations"
import "../../utilities/mathz"


//= Procedures
update :: proc(
	entity : ^game.Entity,
) {
	//* Update movement
	if entity.isMoving {
		//* Move
		//entity.position = mathz.move_entity(
		//	entity.previous,
		//	entity.position,
		//	entity.target,
		//)
		entity.position.y = entity.target.y
		switch entity.direction {
			case .up:
				entity.position.z -= 0.04
				if entity.sprite.animator.currentAnimation != "walk_up" do animations.set_animation(&entity.sprite.animator, "walk_up")
			case .down:
				entity.position.z += 0.04
				if entity.sprite.animator.currentAnimation != "walk_down" do animations.set_animation(&entity.sprite.animator, "walk_down")
			case .left:
				entity.position.x -= 0.04
				if entity.sprite.animator.currentAnimation != "walk_left" do animations.set_animation(&entity.sprite.animator, "walk_left")
			case .right:
				entity.position.x += 0.04
				if entity.sprite.animator.currentAnimation != "walk_right" do animations.set_animation(&entity.sprite.animator, "walk_right")
		}


		//* Check if reached location
		if mathz.approximately(entity.position, entity.target) {
			entity.isMoving = false
			entity.position = entity.target
		}
	} else {
		switch entity.direction {
			case .up:    if entity.sprite.animator.currentAnimation != "idle_up"    do animations.set_animation(&entity.sprite.animator, "idle_up")
			case .down:  if entity.sprite.animator.currentAnimation != "idle_down"  do animations.set_animation(&entity.sprite.animator, "idle_down")
			case .left:  if entity.sprite.animator.currentAnimation != "idle_left"  do animations.set_animation(&entity.sprite.animator, "idle_left")
			case .right: if entity.sprite.animator.currentAnimation != "idle_right" do animations.set_animation(&entity.sprite.animator, "idle_right")
		}
	}
}