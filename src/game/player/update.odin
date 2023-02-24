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

	interact  := raylib.IsKeyPressed(.SPACE)

	if !game.player.entity.isMoving && game.player.canMove && game.battleStruct == nil {
		//* Events
		test : raylib.Vector2 = { game.player.entity.position.x, game.player.entity.position.z }
		if test in game.region.events {
			if !game.region.events[test].interactable && game.player.canMove {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[test]
				return
			}
		}
		if interact {
			switch game.player.entity.direction {
				case .up:		test -= {0,1}
				case .down:		test += {0,1}
				case .left:		test -= {1,0}
				case .right:	test += {1,0}
			}

			if game.region.events[test].interactable {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[test]
			}
			ent, resu := game.region.entities[test]
			var, res := game.eventmanager.eventVariables[ent.visibleVar]
			if resu && (res && var != ent.visible) {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[ent.interactionEvent]
				switch game.player.entity.direction {
					case .up:		entity.turn(&ent, .down)
					case .down:		entity.turn(&ent, .up)
					case .left:		entity.turn(&ent, .right)
					case .right:	entity.turn(&ent, .left)
				}
			}
		}

		if upDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .up)
			else do game.player.entity.direction = .up
			game.player.moveTimer += 1
		}
		if downDown  {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .down)
			else do game.player.entity.direction = .down
			game.player.moveTimer += 1
		}
		if leftDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .left)
			else do game.player.entity.direction = .left
			game.player.moveTimer += 1
		}
		if rightDown {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .right)
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