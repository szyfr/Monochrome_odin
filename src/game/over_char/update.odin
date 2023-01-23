package over_char


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../graphics/sprites/animations"
import "../../utilities"


//= Procedures
update :: proc(
	char : ^OverworldCharacter,
) {
	if char.isMoving {
		//* Move
		switch char.direction {
			case .up:
				char.currentPosition.z -= 0.04
				if char.sprite.animator.currentAnimation != "walk_up" do animations.set_animation(&char.sprite.animator, "walk_up")
			case .down:
				char.currentPosition.z += 0.04
				if char.sprite.animator.currentAnimation != "walk_down" do animations.set_animation(&char.sprite.animator, "walk_down")
			case .left:
				char.currentPosition.x -= 0.04
				if char.sprite.animator.currentAnimation != "walk_left" do animations.set_animation(&char.sprite.animator, "walk_left")
			case .right:
				char.currentPosition.x += 0.04
				if char.sprite.animator.currentAnimation != "walk_right" do animations.set_animation(&char.sprite.animator, "walk_right")
		}

		//* Check if reached location
		if utilities.approximately(char.currentPosition, char.nextPosition) {
			char.isMoving = false
			char.currentPosition = char.nextPosition
		}
	} else {
		switch char.direction {
			case .up:    if char.sprite.animator.currentAnimation != "idle_up"    do animations.set_animation(&char.sprite.animator, "idle_up")
			case .down:  if char.sprite.animator.currentAnimation != "idle_down"  do animations.set_animation(&char.sprite.animator, "idle_down")
			case .left:  if char.sprite.animator.currentAnimation != "idle_left"  do animations.set_animation(&char.sprite.animator, "idle_left")
			case .right: if char.sprite.animator.currentAnimation != "idle_right" do animations.set_animation(&char.sprite.animator, "idle_right")
		}
	}
}