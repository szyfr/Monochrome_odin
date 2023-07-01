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
		// TODO Check attacks
		if settings.is_key_pressed("info")		do game.battleData.playerAction = .interaction
		if settings.is_key_pressed("attack1")	do game.battleData.playerAction = .attack1
		if settings.is_key_pressed("attack2")	do game.battleData.playerAction = .attack2
		if settings.is_key_pressed("attack3")	do game.battleData.playerAction = .attack3
		if settings.is_key_pressed("attack4")	do game.battleData.playerAction = .attack4
		//if settings.is_key_pressed("item")		do game.battleData.playerAction = .item
		//if settings.is_key_pressed("switchin")	do game.battleData.playerAction = .switch_in

		//* Turns
		if game.battleData.playersTurn {
			//* 
			#partial switch game.battleData.playerAction {
				case .interaction:
					if settings.is_key_pressed("leftclick") do arrow_pressed()
					if settings.is_key_down("leftclick") do arrow_down()
					if settings.is_key_released("leftclick") do arrow_released()
					if settings.is_key_pressed("rightclick") {} //TODO INFO
					//if settings.is_key_down("leftclick") {
					//	draw_arrows()
					//	//if len(game.battleData.moveArrowList) == 0 {
					//	//	append(&game.battleData.moveArrowList, game.battleData.target)
					//	//} else if game.battleData.target != game.battleData.moveArrowList[len(game.battleData.moveArrowList)-1] {
					//	//	//TODO Create helper functions to easily remove and manipulate entries
					//	//	append(&game.battleData.moveArrowList, game.battleData.target)
					//	//}
					//}
					//if settings.is_key_down("rightclick") {
					//	
					//}
			//	case .item:
			//	case .switch_in:
				case .attack1:
				case .attack2:
				case .attack3:
				case .attack4:
			}
		} else {
			//* Enemy turn
			game.battleData.playersTurn = true
		}
	}
}