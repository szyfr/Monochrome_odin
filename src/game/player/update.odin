package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../camera"
import "../over_char"


//= Constants
MOVE_WAIT :: 6


//= Procedure
//TODO Check if tile is solid or another level
update :: proc() {
	upDown    := raylib.IsKeyDown(raylib.KeyboardKey.W)
	downDown  := raylib.IsKeyDown(raylib.KeyboardKey.S)
	leftDown  := raylib.IsKeyDown(raylib.KeyboardKey.A)
	rightDown := raylib.IsKeyDown(raylib.KeyboardKey.D)

	if upDown && !data.overworldCharacter.isMoving {
		if data.moveTimer > MOVE_WAIT do over_char.move(.up, &data.overworldCharacter)
		else do data.overworldCharacter.direction = .up
		data.moveTimer += 1
	}
	if downDown && !data.overworldCharacter.isMoving {
		if data.moveTimer > MOVE_WAIT do over_char.move(.down, &data.overworldCharacter)
		else do data.overworldCharacter.direction = .down
		data.moveTimer += 1
	}
	if leftDown && !data.overworldCharacter.isMoving {
		if data.moveTimer > MOVE_WAIT do over_char.move(.left, &data.overworldCharacter)
		else do data.overworldCharacter.direction = .left
		data.moveTimer += 1
	}
	if rightDown && !data.overworldCharacter.isMoving {
		if data.moveTimer > MOVE_WAIT do over_char.move(.right, &data.overworldCharacter)
		else do data.overworldCharacter.direction = .right
		data.moveTimer += 1
	}
	if  !upDown    &&
		!downDown  &&
		!leftDown  &&
		!rightDown {
		data.moveTimer = 0
	}

	over_char.update(&data.overworldCharacter)
	camera.move(data.overworldCharacter.currentPosition)
}