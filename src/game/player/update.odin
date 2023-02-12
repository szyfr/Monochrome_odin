package player


//= Imports
import "core:fmt"

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

	if !game.player.entity.isMoving && game.player.canMove {
		test : raylib.Vector2 = {
			game.player.entity.position.x,
			game.player.entity.position.z,
		}
		if test in game.zones["New Bark Town"].events {
			event := &game.zones["New Bark Town"].events[test]
			#partial switch event.type {
				case .warp:
					position : raylib.Vector3
					position.x = event.data.(raylib.Vector2).x
					position.z = event.data.(raylib.Vector2).y
					position.y = game.zones["New Bark Town"].tiles[int(position.z)][int(position.x)].pos.y
					entity.teleport(game.player.entity, position)
					game.player.moveTimer = 0
			}
		}

		if upDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(.up, game.player.entity)
			else do game.player.entity.direction = .up
			game.player.moveTimer += 1
		}
		if downDown  {
			if game.player.moveTimer > MOVE_WAIT do entity.move(.down, game.player.entity)
			else do game.player.entity.direction = .down
			game.player.moveTimer += 1
		}
		if leftDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(.left, game.player.entity)
			else do game.player.entity.direction = .left
			game.player.moveTimer += 1
		}
		if rightDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(.right, game.player.entity)
			else do game.player.entity.direction = .right
			game.player.moveTimer += 1
		}
	}
	if  !upDown    &&
		!downDown  &&
		!leftDown  &&
		!rightDown {
		game.player.moveTimer = 0
	}

	entity.update(game.player.entity)
}