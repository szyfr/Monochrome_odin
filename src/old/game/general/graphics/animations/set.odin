package animations


//= Imports
import "core:encoding/json"

import "../../../../game"


//= Procedures
set_animation :: proc(
	animator  : ^game.StandeeAnimation,
	animation : string,
) {
	if animator.currentAnimation != animation {
		animator.currentAnimation = animation
		animator.frame = 0
		animator.timer = 0
	}
}