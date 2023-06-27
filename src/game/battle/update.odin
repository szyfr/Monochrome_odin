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

		//* Mode changing
		//if settings.is_key_pressed("info") && game.battleData.playerAction != .info {
		//	game.battleData.playerAction = .info
		//	img := raylib.ImageCopy(game.targeter)
		//	raylib.ImageColorTint(&img, {51,142,0,126})
		//	texture := raylib.LoadTextureFromImage(img)
		//	raylib.UnloadTexture(game.targeterMat.maps[0].texture)
		//	raylib.SetMaterialTexture(
		//		&game.targeterMat,
		//		raylib.MaterialMapIndex.ALBEDO,
		//		texture,
		//	)
		//	raylib.UnloadImage(img)
		//}
		if settings.is_key_pressed("info") && game.battleData.playerAction != .interaction {
			game.battleData.playerAction = .interaction
			//img := raylib.ImageCopy(game.targeter)
			//raylib.ImageColorTint(&img, {247,82,49,255})
			//raylib.UnloadTexture(game.targeterMat.maps[0].texture)
			//texture := raylib.LoadTextureFromImage(img)
			//raylib.SetMaterialTexture(
			//	&game.targeterMat,
			//	raylib.MaterialMapIndex.ALBEDO,
			//	texture,
			//)
			//raylib.UnloadImage(img)
		}
		if settings.is_key_pressed("attack1")	do game.battleData.playerAction = .attack1
		if settings.is_key_pressed("attack2")	do game.battleData.playerAction = .attack2
		if settings.is_key_pressed("attack3")	do game.battleData.playerAction = .attack3
		if settings.is_key_pressed("attack4")	do game.battleData.playerAction = .attack4
		//if settings.is_key_pressed("item")		do game.battleData.playerAction = .item
		//if settings.is_key_pressed("switchin")	do game.battleData.playerAction = .switch_in

		//* 
		#partial switch game.battleData.playerAction {
			case .interaction:
				if settings.is_key_down("leftclick") {
					if game.battleData.target != game.moveArrowList[len(game.moveArrowList)-1] {
						//TODO Create helper functions to easily remove and manipulate entries
						append(&game.moveArrowList, game.battleData.target)
					}
				}
				if settings.is_key_down("rightclick") {
					
				}
		//	case .item:
		//	case .switch_in:
			case .attack1:
			case .attack2:
			case .attack3:
			case .attack4:
		}
	}
}