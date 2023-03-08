package region


//= Imports
import "core:fmt"
import "core:math"
import "core:slice"

import "vendor:raylib"

import "../../../../game"
import "../../../../utilities/mathz"
import "../../entity"


//= Procedures
draw :: proc() {
	if game.DRAW_MAP {
	//	maxY, minY : int = int(game.region.size.y), 0
	//	maxX, minX : int = int(game.region.size.x), 0
		maxY, minY : int = int(game.camera.target.z) + 10, int(game.camera.target.z) - 10
		maxX, minX : int = int(game.camera.target.x) + 16, int(game.camera.target.x) - 16
		width      : int = maxX - minX
		col : raylib.Color = {0,0,0,255}
		for y:=minY;y<maxY;y+=1 {
			count := 0
			x     := minX
			flip  := false
			for count != width {
				position : raylib.Vector2 = {
					f32(x),
					f32(y),
				}
				//raylib.DrawModelEx(
				//	game.tiles[game.region.tiles[position].model],
				//	game.region.tiles[position].pos,
				//	{0, 1, 0},
				//	0,
				//	{1, 1, 1},
				//	{255,255,255,255},
				//)
				raylib.DrawMesh(
					game.tilesTest[game.region.tiles[position].model],
					game.tilesMaterial,
					mathz.mat_trans(game.region.tiles[position].pos),
				)
				if !flip do x += 1
				else     do x -= 1

				if x >= int(game.camera.target.x) && !flip {
					flip = true
					x = maxX-1
				}

				count += 1
			}

			x = 0
			for x:=0;x<int(game.region.size.x);x+=1 {
				ent, err := game.region.entities[{f32(x),f32(y)}]
				if err && game.check_variable(ent.visibleVar, ent.visible) do if test_entity(f32(x), f32(y), &ent, true) do entity.draw(&ent)
				ent, err  = game.region.entities[{f32(x),f32(y-1)}]
				if err && game.check_variable(ent.visibleVar, ent.visible) do if test_entity(f32(x), f32(y), &ent, true) do entity.draw(&ent)
				
				ply := game.player.entity
				if test_entity(f32(x), f32(y), ply, false) do entity.draw(ply)
			}

		}
	}

	if game.region.aniTimer >= 50 {
		game.region.aniTimer = 0
		game.region.frame += 1
		if game.region.frame >= len(game.tilesTexture) do game.region.frame = 0
		raylib.SetMaterialTexture(&game.tilesMaterial, .ALBEDO, game.tilesTexture[game.region.frame])
	} else do game.region.aniTimer += 1
}

test_entity :: proc(
	x, y	: f32,
	entity	: ^game.Entity,
	notPrev	: bool,
) -> bool {
	if notPrev {
		//posZ := y
		posZ := math.ceil(entity.target.z)
		if math.ceil(entity.target.z) < entity.position.z do posZ += 1
		return math.round(entity.target.x) == x && posZ == y
		//return math.round(entity.target.x) == x && math.ceil(entity.target.z) == posZ
	}
	else		do return math.round(entity.position.x) == x && math.ceil(entity.position.z) == y
}