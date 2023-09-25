package data


//= Imports
import "vendor:raylib"


//= Structures
Unit :: struct {
	position, trgPosition : raylib.Vector3,
	direction : Direction,
	
	animator : Animator,
}

Animator :: struct {
	mesh		: raylib.Mesh,
	material	: raylib.Material,
	textures	: [dynamic]raylib.Texture,

	currentAnimation : string,

	frame, counter : int,

}

Animation :: struct {
	frames	: [dynamic]int,
	delay	: int,
}


//= Enumeration
Direction :: enum {
	null,
	north,
	south,
	east,
	west,
}