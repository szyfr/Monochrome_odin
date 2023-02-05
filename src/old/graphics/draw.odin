package graphics


//= Imports
import "core:fmt"
import "core:slice"

import "vendor:raylib"

import "../game"
import "../game/camera"
import "../game/entity"
import "../game/tiles"
import "../game/zone"
import "sprites"
import "standee"


//= Procedures
draw_single :: proc() {
	//* Create a map of pointers to the entities indexed by their position
	entities : map[raylib.Vector3]^game.Entity
	for i:=0;i<len(zone.zones["New Bark Town"].entities);i+=1 {
		ptr := &zone.zones["New Bark Town"].entities[i]
		entities[ptr.position] = ptr
	}

	if game.DRAW_MAP {
		//* First half
		//TODO Entities
		for tile in zone.zones["New Bark Town"].tiles {
			for tile2 in tile {
				if tile2.pos.x < camera.data.target.x-1 {
					raylib.DrawModelEx(
						tiles.data[tile2.model],
						tile2.pos,
						{0, 1, 0},
						0,
						{1, 1, 1},
						raylib.WHITE,
					)
					if tile2.pos in entities {
						draw_entity(entities[tile2.pos])
					}
				}
			}
		}
		//* Second half
		//TODO Entities
		for tile in zone.zones["New Bark Town"].tiles {
			slice.reverse(tile[:])
			for tile2 in tile {
				if tile2.pos.x > camera.data.target.x-1 {
					raylib.DrawModelEx(
						tiles.data[tile2.model],
						tile2.pos,
						{0, 1, 0},
						0,
						{1, 1, 1},
						raylib.WHITE,
					)
					if tile2.pos in entities {
						draw_entity(entities[tile2.pos])
					}
				}
			}
			slice.reverse(tile[:])
		}
	}
}

draw_entity :: proc(
	entity : ^game.Entity,
) {
	standee.draw(&entity.standee)
	//sprites.draw(camera.data, &entity.sprite, entity.position)
}