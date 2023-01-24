package entity


//= Imports
import "vendor:raylib"

import "../tiles"
import "../zone"


//= Procedures
move_entity :: proc(
	direction :  Direction,
	entity    : ^Entity,
) {
	if !entity.isMoving {
		entity.direction = direction

		//* Check if movable
		target : raylib.Vector3
		switch entity.direction {
			case .up:    target = entity.position - {0,0,1}
			case .down:  target = entity.position + {0,0,1}
			case .left:  target = entity.position - {1,0,0}
			case .right: target = entity.position + {1,0,0}
		}

		//* Get tile
		tile : ^tiles.Tile = &zone.zones["New Bark Town"].tiles[int(target.z)][int(target.x)]
		diff :  f32        = tile.pos.y - entity.position.y
		if  tile.solid ||
			(!entity.isSurfing && tile.surf) ||
			(diff > 0.5 || diff < -0.75)
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