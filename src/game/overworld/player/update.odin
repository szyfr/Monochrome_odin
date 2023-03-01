package player


//= Imports
import "../../../game"
import "../../../utilities/mathz"
import "../../overworld/entity"
import "../../general/settings"


//= Constants
MOVE_WAIT :: 6


//= Procedure
update :: proc() {
	vertical	:= settings.get_axis("vertical")
	horizontal	:= settings.get_axis("horizontal")

	interact	:= settings.is_key_pressed("interact")
	pause		:= settings.is_key_pressed("pause")

	if can_move() {
		//* Events
		eventPosition := mathz.to_v2(game.player.entity.position)

		//* Check if event is a trigger
		if eventPosition in game.region.events {
			if !game.region.events[eventPosition].interactable {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[eventPosition]
				return
			}
		}

		//* Interaction
		if interact {
			eventPosition += mathz.to_v2(int(game.player.entity.direction))

			if game.region.events[eventPosition].interactable {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[eventPosition]
			}

			if eventPosition in game.region.entities {
				interactingEntity := &game.region.entities[eventPosition]
				if interactingEntity.visibleVar in game.eventmanager.eventVariables {
					game.player.canMove = false
					game.eventmanager.currentEvent = &game.region.events[interactingEntity.interactionEvent]
					switch game.player.entity.direction {
						case .up:		entity.turn(interactingEntity, .down)
						case .down:		entity.turn(interactingEntity, .up)
						case .left:		entity.turn(interactingEntity, .right)
						case .right:	entity.turn(interactingEntity, .left)
					}
				}
			}
		}

		//* Player Movement
		if vertical > 0 {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .up)
			else do game.player.entity.direction = .up
			game.player.moveTimer += 1
		}
		if vertical < 0  {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .down)
			else do game.player.entity.direction = .down
			game.player.moveTimer += 1
		}
		if horizontal > 0 {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .left)
			else do game.player.entity.direction = .left
			game.player.moveTimer += 1
		}
		if horizontal < 0 {
			if game.player.moveTimer > MOVE_WAIT do entity.move(game.player.entity, .right)
			else do game.player.entity.direction = .right
			game.player.moveTimer += 1
		}
	}
	if vertical == 0 && horizontal == 0 do game.player.moveTimer = 0

	//* Pause menu
	if pause {
		game.player.pauseMenu = !game.player.pauseMenu
	}

	entity.update(game.player.entity)
}

can_move :: proc() -> bool {
	return !game.player.entity.isMoving && game.player.canMove && game.battleStruct == nil && !game.player.pauseMenu
}