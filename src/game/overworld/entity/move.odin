package entity


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../../game"
import "../../general/graphics/animations"
import "../../general/audio"


//= Procedures

//* Make entity take step
move :: proc(
	entity    : ^game.Entity,
	direction :  game.Direction,
) {
	if !entity.isMoving {
		entity.direction = direction

		//* Check if movable
		target : raylib.Vector3
		switch entity.direction {
			case .up:    target = entity.position - { 0, 0, 1 }
			case .down:  target = entity.position + { 0, 0, 1 }
			case .left:  target = entity.position - { 1, 0, 0 }
			case .right: target = entity.position + { 1, 0, 0 }
		}

		//* Get tile
		tile : ^game.Tile	 = &game.region.tiles[{target.x, target.z}]
		diff :  f32			 = tile.pos.y - entity.position.y
		ent, res			:= game.region.entities[{target.x, target.z}]
		var, resu			:= game.eventmanager.eventVariables[ent.visibleVar]
		if  tile.solid ||                      		//? Tile is solid
			(!entity.isSurfing && tile.surf) ||		//? Tile is surfable and playing isn't surfing
			(diff > 0.5 || diff < -0.75) ||    		//? Height difference is too extreme
			(res && ((resu && ent.visible != var) || ent.visibleVar == ""))	//? There is currently an entity there
		{
			if game.player.entity == entity do audio.play_sound("collision")
			//TODO Thump noise
			//TODO Slow walking animation?
			return
		}
		if tile.pos.y != entity.position.y do target.y = tile.pos.y

		//* Move
		entity.isMoving = true
		entity.previous = entity.position
		entity.target   = target
		
		if game.player.entity != entity {
			value := entity^
			position : raylib.Vector2
			position.x = value.previous.x
			position.y = value.previous.z
			delete_key(&game.region.entities, position)
			position.x = value.target.x
			position.y = value.target.z
			game.region.entities[position] = value
		}
	}
}

//* Teleport entity
teleport :: proc(
	entity		: ^game.Entity,
	location	:  raylib.Vector3,
) {
	entity.position = location
	entity.previous = location
	entity.target   = location
}

turn :: proc(
	entity		: ^game.Entity,
	direction	:  game.Direction,
) {
	switch direction {
		case .up:		animations.set_animation(&entity.standee.animator, "idle_up")
		case .down:		animations.set_animation(&entity.standee.animator, "idle_down")
		case .left:		animations.set_animation(&entity.standee.animator, "idle_left")
		case .right:	animations.set_animation(&entity.standee.animator, "idle_right")
	}
	entity.direction = direction
}