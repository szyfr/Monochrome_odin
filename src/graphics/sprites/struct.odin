package sprites


//= Imports
import "vendor:raylib"

import "animations"


//= Structures
Sprite :: struct {
	width    : u32,
	height   : u32,

	position : raylib.Vector3,

	low      : ^raylib.Texture2D,
	mid      : ^raylib.Texture2D,
	high     : ^raylib.Texture2D,

	animator : animations.AnimationController,
}