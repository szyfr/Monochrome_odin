package game


//= Imports
import "vendor:raylib"


//= Structures
EmoteStruct_ :: struct {
	src, dest	: raylib.Rectangle,
	charPos		: raylib.Vector2,
	duration	: int,
	maxDuration : int,
	player		: bool,
}

EmoteStruct :: struct {
	transform	:  raylib.Matrix,
	mesh		: ^raylib.Mesh,
	material	: ^raylib.Material,

	duration	: int,
}