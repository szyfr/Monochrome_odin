package overworld


//= Imports
import "../../../game"
import "../../../debug"


//= Procedures
play_animation :: proc( entity : ^game.Entity, animation : string ) {
	newAnimation := animation
	_, result := entity.animator.animations[animation]
	if !result {
		debug.log("[ERROR] - Attempted to play an animation that didn't exist")
		newAnimation = "idle_down"
	}

	if entity.animator.currentAnimation != newAnimation {
		entity.animator.currentAnimation = newAnimation
		entity.animator.frame = 0
		entity.animator.timer = 0
		entity.animator.material.maps[0].texture = entity.animator.textures[entity.animator.animations[entity.animator.currentAnimation].frames[entity.animator.frame]]
	}
}