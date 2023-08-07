package overworld


//= Imports
import "vendor:raylib"

import "../../../game"


//= Procedures

//* Standard move
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
	//	ent, res			:= game.region.entities[{target.x, target.z}]
		res := false
		for enti in game.region.entities do if game.region.entities[enti].position == target do res = true
			//(res && check_visible(&ent))			//? There is currently an entity there
		if  tile.solid ||                      		//? Tile is solid
			(!entity.isSurfing && tile.surf) ||		//? Tile is surfable and playing isn't surfing
			(diff > 0.5 || diff < -0.75) ||    		//? Height difference is too extreme
			res
		{
			//TODO Audio
			//if game.player.entity == entity do audio.play_sound("collision")
			//TODO Slow walking animation?
			return
		}
		if tile.pos.y != entity.position.y do target.y = tile.pos.y

		//* Move
		entity.isMoving = true
		entity.previous = entity.position
		entity.target   = target
		
		if game.player.entity != entity {
		//	value := entity^
		//	position : raylib.Vector2
		//	position.x = value.previous.x
		//	position.y = value.previous.z
		//	delete_key(&game.region.entities, position)
		//	position.x = value.target.x
		//	position.y = value.target.z
		//	game.region.entities[position] = value
		}
	}
}

//* Push
push :: proc(
	entity		: ^game.Entity,
	direction	:  game.Direction,
) {

}

//* Teleport entity
teleport :: proc(
	entity		: ^game.Entity,
	location	:  raylib.Vector3,
) {
	entity.previous = entity.position
	entity.position = location
	entity.target   = location

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

//* Turn
turn :: proc(
	entity		: ^game.Entity,
	direction	:  game.Direction,
	moveAnim	:  bool = false,
) {
	switch direction {
		case .up:
			if !moveAnim	do play_animation(entity, "idle_up")
			else			do play_animation(entity, "walk_up")
		case .down:
			if !moveAnim	do play_animation(entity, "idle_down")
			else			do play_animation(entity, "walk_down")
		case .left:
			if !moveAnim	do play_animation(entity, "idle_left")
			else			do play_animation(entity, "walk_left")
		case .right:
			if !moveAnim	do play_animation(entity, "idle_right")
			else			do play_animation(entity, "walk_right")
	}
	entity.direction = direction
}

check_visible :: proc(entity : ^game.Entity) -> bool {
	return true
}