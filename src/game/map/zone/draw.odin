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

	if game.DRAW_MAP {
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
					if  ( int(math.ceil(ent.target.x)) == x   || int(math.floor(ent.target.x)) == x   ) &&
						( int(math.ceil(ent.target.z)) == y-1 || int(math.floor(ent.target.z)) == y-1 ) {
						entity.draw(entities[e])
					}
				}
			}
		}
	}
}