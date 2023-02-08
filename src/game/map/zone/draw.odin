package zone


//= Imports
import "core:fmt"
import "core:math"
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
	entities[game.player.entity.position] = game.player.entity
	for i:=0;i<len(game.zones["New Bark Town"].entities);i+=1 {
		ptr := &game.zones["New Bark Town"].entities[i]
		entities[ptr.position] = ptr
	}

	for y:=0;y<int(game.zones["New Bark Town"].height);y+=1 {
		for x:=0;x<int(game.player.entity.position.x);x+=1 {
			raylib.DrawModelEx(
				game.tiles[game.zones["New Bark Town"].tiles[y][x].model],
				game.zones["New Bark Town"].tiles[y][x].pos,
				{0, 1, 0},
				0,
				{1, 1, 1},
				raylib.WHITE,
			)
			for e in entities {
				ent := entities[e]
				if  ( int(math.ceil(ent.target.x)) == x || int(math.floor(ent.target.x)) == x ) &&
					( int(math.ceil(ent.target.z)) == y || int(math.floor(ent.target.z)) == y ) {
					entity.draw(entities[e])
				}
			}
		}
		for x:=int(game.zones["New Bark Town"].width)-1;x>int(game.player.entity.position.x)-1;x-=1 {
			raylib.DrawModelEx(
				game.tiles[game.zones["New Bark Town"].tiles[y][x].model],
				game.zones["New Bark Town"].tiles[y][x].pos,
				{0, 1, 0},
				0,
				{1, 1, 1},
				raylib.WHITE,
			)
			for e in entities {
				ent := entities[e]
				if  ( int(math.ceil(ent.target.x)) == x || int(math.floor(ent.target.x)) == x ) &&
					( int(math.ceil(ent.target.z)) == y-1 || int(math.floor(ent.target.z)) == y-1 ) {
					entity.draw(entities[e])
				}
			}
		}
	}

	
	//for tile in game.zones["New Bark Town"].tiles {
	//	raylib.DrawModelEx(
	//		game.tiles[tile[8].model],
	//		tile[8].pos,
	//		{0, 1, 0},
	//		0,
	//		{1, 1, 1},
	//		raylib.WHITE,
	//	)
	//	if tile[8].pos in entities {
	//		entity.draw(entities[tile[8].pos])
	//	}
	//	//for tile2 in tile {
	//	//	raylib.DrawModelEx(
	//	//		game.tiles[tile2.model],
	//	//		tile2.pos,
	//	//		{0, 1, 0},
	//	//		0,
	//	//		{1, 1, 1},
	//	//		raylib.WHITE,
	//	//	)
	//	//	if tile2.pos in entities {
	//	//		entity.draw(entities[tile2.pos])
	//	//	}
	//	//}
	//}

	//TODO Rework so that it is drawn row by row
	//if game.DRAW_MAP {
	//	//* First half
	//	//TODO Entities
	//	for tile in game.zones["New Bark Town"].tiles {
	//		for tile2 in tile {
	//			if tile2.pos.x < game.camera.target.x-1 {
	//				raylib.DrawModelEx(
	//					game.tiles[tile2.model],
	//					tile2.pos,
	//					{0, 1, 0},
	//					0,
	//					{1, 1, 1},
	//					raylib.WHITE,
	//				)
	//				if tile2.pos in entities {
	//					//entity := entities[tile2.pos]
	//					//if entity
	//					entity.draw(entities[tile2.pos])
	//				}
	//			}
	//		}
	//	}
	//	//* Second half
	//	//TODO Entities
	//	for tile in game.zones["New Bark Town"].tiles {
	//		slice.reverse(tile[:])
	//		for tile2 in tile {
	//			if tile2.pos.x > game.camera.target.x-1 {
	//				raylib.DrawModelEx(
	//					game.tiles[tile2.model],
	//					tile2.pos,
	//					{0, 1, 0},
	//					0,
	//					{1, 1, 1},
	//					raylib.WHITE,
	//				)
	//				if tile2.pos in entities {
	//					entity.draw(entities[tile2.pos])
	//				}
	//				//if game.player.entity.target.z >= tile2.pos.z {
	//				//	entity.draw(game.player.entity)
	//				//}
	//			}
	//		}
	//		slice.reverse(tile[:])
	//	}
	//}
}