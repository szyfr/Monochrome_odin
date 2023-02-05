package standee


//= Imports
import "vendor:raylib"


//= Procedures
update :: proc(
	standee : ^Standee,
) {

}

set_position :: proc(
	standee  : ^Standee,
	position :  raylib.Vector3,
) {
	
}

set_animation :: proc(
	standee   : ^Standee,
	animation :  string,
) {
	standee.animator.frame = 0
	standee.animator.timer = 0
	standee.animator.currentAnimation = animation
}