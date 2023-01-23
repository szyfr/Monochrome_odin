package animations


//= Imports


//= Procedures
set_animation :: proc(
	animator  : ^AnimationController,
	animation : string,
) {
	animator.currentAnimation = animation
	animator.frame = 0
	animator.timer = 0
}