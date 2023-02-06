package player


//= Imports
import "vendor:raylib"

import "../../game"
import "../../game/entity"


//= Constants
MOVE_WAIT :: 6


//= Procedure
update :: proc() {
	upDown    := raylib.IsKeyDown(raylib.KeyboardKey.W)
	downDown  := raylib.IsKeyDown(raylib.KeyboardKey.S)
	leftDown  := raylib.IsKeyDown(raylib.KeyboardKey.A)
	rightDown := raylib.IsKeyDown(raylib.KeyboardKey.D)

	if upDown && !game.player.entity.isMoving {
		if game.player.moveTimer > MOVE_WAIT do entity.move_entity(.up, game.player.entity)
		else do game.player.entity.direction = .up
		game.player.moveTimer += 1
	}
	if downDown && !game.player.entity.isMoving {
		if game.player.moveTimer > MOVE_WAIT do entity.move_entity(.down, game.player.entity)
		else do game.player.entity.direction = .down
		game.player.moveTimer += 1
	}
	if leftDown && !game.player.entity.isMoving {
		if game.player.moveTimer > MOVE_WAIT do entity.move_entity(.left, game.player.entity)
		else do game.player.entity.direction = .left
		game.player.moveTimer += 1
	}
	if rightDown && !game.player.entity.isMoving {
		if game.player.moveTimer > MOVE_WAIT do entity.move_entity(.right, game.player.entity)
		else do game.player.entity.direction = .right
		game.player.moveTimer += 1
	}
	if  !upDown    &&
		!downDown  &&
		!leftDown  &&
		!rightDown {
		game.player.moveTimer = 0
	}

	entity.update(game.player.entity)
}