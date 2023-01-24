package graphics


//= Imports
import "core:slice"

import "vendor:raylib"

import "../game"
import "../game/camera"
import "../game/entity"
import "../game/tiles"
import "../game/zone"
import "sprites"


//= Procedures
draw_single :: proc() {
	//* Create a map of pointers to the entities indexed by their position

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
				}
			}
			slice.reverse(tile[:])
		}
	}
}

draw_entity :: proc(
	entity : ^entity.Entity,
) {
	sprites.draw(camera.data, &entity.sprite)
}