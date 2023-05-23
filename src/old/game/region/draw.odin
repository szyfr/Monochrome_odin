package region


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc() {
	maxY, minY := int(game.camera.target.z) + 10, int(game.camera.target.z) - 10
	maxX, minX := int(game.camera.target.x) + 16, int(game.camera.target.x) - 16
	width      := maxX - minX
	col : raylib.Color = {0,0,0,255}
	for y:=minY;y<maxY;y+=1 {
		count	:= 0
		x		:= minX
		flip	:= false
		for count != width {
			position : raylib.Vector2 = {
				f32(x),
				f32(y),
			}
			raylib.DrawModelEx(
				game.tiles[game.region.tiles[position].model],
				game.region.tiles[position].pos,
				{0, 1, 0},
				0,
				{1, 1, 1},
				{255,255,255,255},
			)
			//tile := game.region.tiles[position]
			//transform : raylib.Matrix = {
			//	1,0,0,0,
			//	0,1,0,0,
			//	0,0,1,0,
			//	0,0,0,0,
			//}
			//transform[3,0] = position.x
			//transform[3,2] = position.y
			//transform : raylib.Matrix = {
			//	1,0,0,tile.pos.x,
			//	0,1,0,0,
			//	0,0,1,tile.pos.y,
			//	0,0,0,0,
			//}
			//if tile.model != "null" && tile.model != "" {
			//	raylib.DrawMesh(
			//		game.tilesTest[tile.model],
			//		game.tilesMaterial,
			//		transform,
			//	)
			//}
			if !flip do x += 1
			else     do x -= 1

			if x >= int(game.camera.target.x) && !flip {
				flip = true
				x = maxX-1
			}

			count += 1
		}
	}
}