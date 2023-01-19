package sprites


//= Imports
import "vendor:raylib"

import "animations"


//= Structures
Sprite :: struct {
	texture  : raylib.Texture2D,
	size     : raylib.Vector2,

	animator : animations.AnimationController,
}