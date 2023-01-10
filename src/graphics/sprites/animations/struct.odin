package animations


//= Imports
import "vendor:raylib"


//= Structures
AnimationController :: struct {
	currentAnimation : u32,
	frame : u32,
	timer : u32,

	animations : [dynamic]Animation,
}

Animation :: struct {
	animationSpeed : u32,
	frames : [dynamic]u32,
}