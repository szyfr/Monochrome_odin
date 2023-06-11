package battle


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../game"
import "../../settings"
import "../entity/overworld"


//= Procedures
update :: proc() {
	if game.battleData != nil {
		//* Monsters


		//* Player cursor
		ray := raylib.GetMouseRay(raylib.GetMousePosition(), game.camera)
		col : raylib.RayCollision

		for y:=0;y<8;y+=1 {
			for x:=0;x<16;x+=1 {
				col = raylib.GetRayCollisionBox(
					ray,
					{
						{f32(x) + 9, 0, f32(y) + 56},
						{f32(x) + 8, 0, f32(y) + 57},
					},
				)
				if col.hit {
					game.battleData.target = {math.ceil(f32(x)),math.ceil(f32(y))}
					break
				}
			}
		}

		if settings.is_key_pressed("up") && game.battleData.target.y != 0 do game.battleData.target.y -= 1
		if settings.is_key_pressed("down") && game.battleData.target.y != 8 do game.battleData.target.y += 1
		if settings.is_key_pressed("left") && game.battleData.target.x != 0 do game.battleData.target.x -= 1
		if settings.is_key_pressed("right") && game.battleData.target.x != 16 do game.battleData.target.x += 1
	}
}