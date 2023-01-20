package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../over_char"


//= Procedure
update :: proc() {
	mod : raylib.Vector3 = {}
	if raylib.IsKeyPressed(raylib.KeyboardKey.W) do over_char.move(.up,    &data.overworldCharacter)
	if raylib.IsKeyPressed(raylib.KeyboardKey.S) do over_char.move(.down,  &data.overworldCharacter)
	if raylib.IsKeyPressed(raylib.KeyboardKey.A) do over_char.move(.left,  &data.overworldCharacter)
	if raylib.IsKeyPressed(raylib.KeyboardKey.D) do over_char.move(.right, &data.overworldCharacter)
	fmt.printf("shid\n")
	//camera.target   += mod
	//camera.position += mod

	over_char.update(&data.overworldCharacter)
	data.camera.target   = data.overworldCharacter.currentPosition
	data.camera.position = data.camera.target + {0, 7, 2.5}
}