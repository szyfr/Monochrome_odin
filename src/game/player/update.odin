package player


//= Imports
import "core:fmt"

import "../../game"
import "../entity/overworld"
import "../../settings"


//= Procedures
update :: proc() {
	vertical	:= settings.get_axis("vertical")
	horizontal	:= settings.get_axis("horizontal")
	interact	:= settings.is_key_pressed("interact")
	pause		:= settings.is_key_pressed("pause")

	if can_move() {
		//TODO Events
		//TODO Triggers
		event, result := game.region.triggers[{game.player.entity.position.x, game.player.entity.position.z}]
		if result {
			// TODO: Call event
		}
		//TODO Interaction

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

	overworld.update(game.player.entity)
}

can_move :: proc() -> bool {
	return !game.player.entity.isMoving && game.player.canMove// && game.player.menu == .none && game.battleStruct == nil
}