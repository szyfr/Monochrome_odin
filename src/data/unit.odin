package data


//= Imports
import "vendor:raylib"


//= Structures
Unit :: struct {
	display : UnitDisplay,

	position, trgPosition : raylib.Vector3,
}

UnitDisplay :: struct {
	mesh : raylib.Mesh,
	material : raylib.Material,
	texture : raylib.Texture,
	image : raylib.Image,

	frameCount, frame, delay : int,
}