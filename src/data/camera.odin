package data


//= Imports
import "vendor:raylib"


//= Structures
Camera :: struct {
	rl : raylib.Camera3D,
	offset : raylib.Vector3,

	position, trgPosition : raylib.Vector3,
	rotation, trgRotation : f32,

	targetUnit : ^Unit,
}