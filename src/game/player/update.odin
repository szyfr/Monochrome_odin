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

	interact  := raylib.IsKeyDown(.SPACE)

	if !game.player.entity.isMoving && game.player.canMove {
		test : raylib.Vector2 = {
			game.player.entity.position.x,
			game.player.entity.position.z,
		}
		if test in game.region.events {
			event := game.region.events[test]
			
			//TODO Event handler
			if !event.interactable {
				if type_of(event.chain[0].(raylib.Vector3)) == raylib.Vector3 {
					entity.teleport(game.player.entity, event.chain[0].(raylib.Vector3))
					entity.move(.up, game.player.entity)
				}
			}
		}
		if interact {
			switch game.player.entity.direction {
				case .up:		test -= {0,1}
				case .down:		test += {0,1}
				case .left:		test -= {1,0}
				case .right:	test += {1,0}
			}
			event := game.region.events[test]

			if event.interactable {
				for i in event.chain do fmt.printf("%v\n",i.(^cstring)^)
				
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