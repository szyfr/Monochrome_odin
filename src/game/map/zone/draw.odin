package zone


//= Imports
import "core:fmt"
import "core:slice"

import "vendor:raylib"

import "../../../game"
import "../../../game/camera"
import "../../../game/entity"
import "../../../game/standee"
import "../../../game/map/tiles"
import "../../../game/map/zone"


//= Procedures
draw_single :: proc() {
	//* Create a map of pointers to the entities indexed by their position
	entities : map[raylib.Vector3]^game.Entity
	entities[game.player.entity.target] = game.player.entity
	for i:=0;i<len(game.zones["New Bark Town"].entities);i+=1 {
		ptr := &game.zones["New Bark Town"].entities[i]
		entities[ptr.position] = ptr
	}

	//for tile in game.zones["New Bark Town"].tiles {
	//	for tile2 in tile {
	//		raylib.DrawModelEx(
	//			game.tiles[tile2.model],
	//			tile2.pos,
	//			{0, 1, 0},
	//			0,
	//			{1, 1, 1},
	//			raylib.WHITE,
	//		)
	//		if tile2.pos in entities {
	//			entity.draw(entities[tile2.pos])
	//		}
	//	}
	//}

	//TODO Rework so that it is drawn row by row
	if game.DRAW_MAP {
		//* First half
		//TODO Entities
		for tile in game.zones["New Bark Town"].tiles {
			for tile2 in tile {
				if tile2.pos.x < game.camera.target.x-1 {
					raylib.DrawModelEx(
						game.tiles[tile2.model],
						tile2.pos,
						{0, 1, 0},
						0,
						{1, 1, 1},
						raylib.WHITE,
					)
					if tile2.pos in entities {
						entity.draw(entities[tile2.pos])
					}
				}
			}
		}
		//* Second half
		//TODO Entities
		for tile in game.zones["New Bark Town"].tiles {
			slice.reverse(tile[:])
			for tile2 in tile {
				if tile2.pos.x > game.camera.target.x-1 {
					raylib.DrawModelEx(
						game.tiles[tile2.model],
						tile2.pos,
						{0, 1, 0},
						0,
						{1, 1, 1},
						raylib.WHITE,
					)
					if tile2.pos in entities {
						entity.draw(entities[tile2.pos])
					}
					//if game.player.entity.target.z >= tile2.pos.z {
					//	entity.draw(game.player.entity)
					//}
				}
			}
			slice.reverse(tile[:])
		}
	}
}