package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../entity"


//= Constants
MOVE_WAIT :: 6


//= Procedure
update :: proc() {
	upDown    := raylib.IsKeyDown(raylib.KeyboardKey.W)
	downDown  := raylib.IsKeyDown(raylib.KeyboardKey.S)
	leftDown  := raylib.IsKeyDown(raylib.KeyboardKey.A)
	rightDown := raylib.IsKeyDown(raylib.KeyboardKey.D)

	if upDown && !data.entity.isMoving {
		if data.moveTimer > MOVE_WAIT do entity.move_entity(.up, &data.entity)
		else do data.entity.direction = .up
		data.moveTimer += 1
	}
	if downDown && !data.entity.isMoving {
		if data.moveTimer > MOVE_WAIT do entity.move_entity(.down, &data.entity)
		else do data.entity.direction = .down
		data.moveTimer += 1
	}
	if leftDown && !data.entity.isMoving {
		if data.moveTimer > MOVE_WAIT do entity.move_entity(.left, &data.entity)
		else do data.entity.direction = .left
		data.moveTimer += 1
	}
	if rightDown && !data.entity.isMoving {
		if data.moveTimer > MOVE_WAIT do entity.move_entity(.right, &data.entity)
		else do data.entity.direction = .right
		data.moveTimer += 1
	}
	if  !upDown    &&
		!downDown  &&
		!leftDown  &&
		!rightDown {
		data.moveTimer = 0
	}

	entity.update(&data.entity)
}