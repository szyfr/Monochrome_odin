package entity


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures

//* Make entity take step
move :: proc(
	direction :  game.Direction,
	entity    : ^game.Entity,
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
		tile : ^game.Tile = &game.zones["New Bark Town"].tiles[int(target.z)][int(target.x)]
		diff :  f32       = tile.pos.y - entity.position.y
		ent  :  bool      = false
		for entity in game.zones["New Bark Town"].entities {
			if entity.position == target do ent = true
		}
		if  tile.solid ||                       //? Tile is solid
			(!entity.isSurfing && tile.surf) || //? Tile is surfable and playing isn't surfing
			(diff > 0.5 || diff < -0.75) ||     //? Height difference is too extreme
			ent                                 //? There is currently an entity there
		{
			//TODO Thump noise
			//TODO Slow walking animation?
			return
		}
		if tile.pos.y != entity.position.y do target.y = tile.pos.y

		//* Move
		entity.isMoving = true
		entity.target   = target
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