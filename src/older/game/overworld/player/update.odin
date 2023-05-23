package player


//= Imports
import "core:fmt"

import "../../../game"
import "../../../utilities/mathz"
import "../../overworld/entity"
import "../../overworld/events"
import "../../general/settings"
import "../../general/audio"


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
			event := game.region.events[eventPosition]
			//visible, result := game.eventmanager.eventVariables[event.visibleVar]
			if !event.interactable && events.check_visible(&event) {
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[eventPosition]
				return
			}
		}

		//* Interaction
		if interact {
			eventPosition += mathz.to_v2(int(game.player.entity.direction))

			if game.region.events[eventPosition].interactable {
				audio.play_sound("button")
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[eventPosition]
			}

			if eventPosition in game.region.entities {
				audio.play_sound("button")
				interactingEntity := &game.region.entities[eventPosition]
				if entity.check_visible(interactingEntity) {
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
	if pause && game.eventmanager.currentEvent == nil && game.battleStruct == nil {
		if game.player.menu != .pause do game.player.menu = .pause
		else if game.player.menu == .pause do game.player.menu = .none
		audio.play_sound("menu")
	}

	entity.update(game.player.entity)
}

can_move :: proc() -> bool {
	return !game.player.entity.isMoving && game.player.canMove && game.battleStruct == nil && game.player.menu == .none
}