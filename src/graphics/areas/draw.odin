package areas


//= Imports
import "core:fmt"
import "core:slice"

import "vendor:raylib"

import "../tiles"
import "../../game"


//= Procedures
draw_single_area :: proc(
	camera : raylib.Camera3D,
	area   : AreaMap,
) {
	if game.DRAW_MAP {
		//* First half
		for tile in area.tilesls {
			for tile2 in tile {
				if tile2.pos.x < camera.target.x-1 {
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
		for tile in area.tilesls {
			slice.reverse(tile[:])
			for tile2 in tile {
				if tile2.pos.x > camera.target.x-1 {
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