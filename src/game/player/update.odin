package player


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"
import "../audio"
import "../../settings"


//= Procedures
update :: proc() {
	vertical	:= settings.get_axis("vertical")
	horizontal	:= settings.get_axis("horizontal")
	interact	:= settings.is_key_pressed("interact")
	pause		:= settings.is_key_pressed("pause")

	if can_move() {
		//TODO Events
		//* Triggers
		event, result := game.region.triggers[{game.player.entity.position.x, game.player.entity.position.z}]
		if result {
			game.player.canMove = false
			game.eventmanager.currentEvent = &game.region.events[event]
		}
		//TODO Interaction
		if interact {
			front : raylib.Vector2
			switch game.player.entity.direction {
				case .up:
					front = {
						game.player.entity.position.x,
						game.player.entity.position.z - 1,
					}
				case .down:
					front = {
						game.player.entity.position.x,
						game.player.entity.position.z + 1,
					}
				case .left:
					front = {
						game.player.entity.position.x - 1,
						game.player.entity.position.z,
					}
				case .right:
					front = {
						game.player.entity.position.x + 1,
						game.player.entity.position.z,
					}
			}
			entity, result := game.region.entities[front]
			if result {
				audio.play_sound("button")

				evt : string
				for event in entity.events {
					// TODO: check for conditionals
					if len(event.conditions) == 0 {
						evt = event.id
						break
					}
				}
				game.player.canMove = false
				game.eventmanager.currentEvent = &game.region.events[evt]

				ent := &game.region.entities[front]
				switch game.player.entity.direction {
					case .up:		ent.direction = .down
					case .down:		ent.direction = .up
					case .left:		ent.direction = .right
					case .right:	ent.direction = .left
				}
			}
		}

		//* Player Movement
		if vertical > 0 {
			if game.player.moveTimer > 6 do overworld.move(game.player.entity, .up)
			else do game.player.entity.direction = .up
			game.player.moveTimer += 1
		}
		if vertical < 0 {
			if game.player.moveTimer > 6 do overworld.move(game.player.entity, .down)
			else do game.player.entity.direction = .down
			game.player.moveTimer += 1
		}
		if horizontal > 0 {
			if game.player.moveTimer > 6 do overworld.move(game.player.entity, .left)
			else do game.player.entity.direction = .left
			game.player.moveTimer += 1
		}
		if horizontal < 0 {
			if game.player.moveTimer > 6 do overworld.move(game.player.entity, .right)
			else do game.player.entity.direction = .right
			game.player.moveTimer += 1
		}
	}
	if vertical == 0 && horizontal == 0 do game.player.moveTimer = 0

	//* Pause menu
	if pause && game.eventmanager.currentEvent == nil {//&& game.battleStruct == nil {
		if game.player.menu != .pause do game.player.menu = .pause
		else if game.player.menu == .pause do game.player.menu = .none
		audio.play_sound("menu")
	}

	overworld.update(game.player.entity)
}

can_move :: proc() -> bool {
	return !game.player.entity.isMoving && game.player.canMove && game.player.menu == .none //&& game.battleStruct == nil
}