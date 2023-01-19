package animations


//= Imports
import "vendor:raylib"


//= Structures
AnimationController :: struct {
	currentAnimation : string,
	frame : u32,
	timer : u32,

	animations : map[string]Animation,
}

Animation :: struct {
	animationSpeed : u32,
	frames : [dynamic]u32,
}