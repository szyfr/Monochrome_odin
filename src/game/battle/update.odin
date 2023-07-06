package battle


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../game"
import "../../settings"
import "../monsters"
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

		//* Player Direction
		player := &game.battleData.field["player"]
		difference : raylib.Vector2 = {player.entity.position.x-8, player.entity.position.z-55.75} - game.battleData.target
		differenceAbs : raylib.Vector2 = {math.abs(difference.x), math.abs(difference.y)}
		if difference.x > 0 && differenceAbs.x >= differenceAbs.y {
			player.entity.direction = .left
			overworld.play_animation(&player.entity, "walk_left")
		}
		if difference.x < 0 && differenceAbs.x >= differenceAbs.y {
			player.entity.direction = .right
			overworld.play_animation(&player.entity, "walk_right")
		}
		if difference.y < 0 && differenceAbs.x < differenceAbs.y {
			player.entity.direction = .down
			overworld.play_animation(&player.entity, "walk_down")
		}
		if difference.y > 0 && differenceAbs.x < differenceAbs.y {
			player.entity.direction = .up
			overworld.play_animation(&player.entity, "walk_up")
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
			if game.battleData.movementTimer != 0 {
				if game.battleData.movementTimer == 1 {
					//* Set new position
					game.battleData.movementTimer = 10
					ply := &game.battleData.field["player"]
					vec := game.battleData.moveArrowList[0]
					ply.entity.position = {vec.x + 8, 0, vec.y + 55.75}

					//* Change movement
					game.battleData.playerTeam[game.battleData.currentPlayer].movesCur -= 1

					//* Edit Arrow
					undercut_arrow()

					//* Check if continues
					if len(game.battleData.moveArrowList) == 0 {
						game.battleData.movementTimer = 0
					}
				} else do game.battleData.movementTimer -= 1
			} else {
				//* 
				#partial switch game.battleData.playerAction {
					case .interaction:
						if game.battleData.playerTeam[game.battleData.currentPlayer].movesCur > 0 {
							if settings.is_key_pressed("leftclick") do arrow_pressed()
							if settings.is_key_down("leftclick") do arrow_down()
							if settings.is_key_released("leftclick") do arrow_released()
						}
						if settings.is_key_pressed("rightclick") {} //TODO INFO
						if settings.is_key_pressed("interact") &&
								game.battleData.playerTeam[game.battleData.currentPlayer].movesCur > 0 &&
								len(game.battleData.moveArrowList) > 0 {
							game.battleData.movementTimer = 10
							game.battleData.movementOffset = 0
						}
				//	case .item:
				//	case .switch_in:
					case .attack1:
						if settings.is_key_pressed("leftclick") do use_attack(0)
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack2:
						if settings.is_key_pressed("leftclick") do use_attack(1)
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack3:
						if settings.is_key_pressed("leftclick") do use_attack(2)
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack4:
						if settings.is_key_pressed("leftclick") do use_attack(3)
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
				}
			}
		} else {
			//* Enemy turn
			game.battleData.playersTurn = true
			monsters.start_turn(&game.battleData.playerTeam[game.battleData.currentPlayer])
		}
	}
}

undercut_arrow :: proc() {
	temp : [dynamic]raylib.Vector2

	for i:=1;i<len(game.battleData.moveArrowList);i+=1 {
		append(&temp, game.battleData.moveArrowList[i])
	}
	delete(game.battleData.moveArrowList)
	game.battleData.moveArrowList = temp
}

use_attack :: proc( value : int ) {
	attack : game.MonsterAttack = game.battleData.playerTeam[game.battleData.currentPlayer].attacks[value]
	enemy := &game.battleData.enemyTeam[game.battleData.currentEnemy]
	enemyToken := &game.battleData.field["enemy"]
	enemyPosition : raylib.Vector2 ={enemyToken.entity.position.x-8, enemyToken.entity.position.z-55.75}
	player := &game.battleData.playerTeam[game.battleData.currentPlayer]
	playerToken := &game.battleData.field["player"]
	playerPosition : raylib.Vector2 = {playerToken.entity.position.x-8, playerToken.entity.position.z-55.75}

	#partial switch attack {
		case .tackle:
			if player.stCur >= 2 {
				offset : raylib.Vector2
				switch playerToken.entity.direction {
					case .up:		offset = { 0,-1}
					case .down:		offset = { 0, 1}
					case .left:		offset = {-1, 0}
					case .right:	offset = { 1, 0}
				}
				//* Push enemy and deal damage
				if enemyPosition == (playerPosition + offset) {
					//* Check if enemy would hit wall or edge
					if spot_empty(enemyPosition + offset) {
						enemyToken.entity.position += {offset.x, 0, offset.y}
						playerToken.entity.position += {offset.x, 0, offset.y}

						enemy.hpCur -= (((((2*player.level)/5)+2)*35*(player.atk/enemy.def))/50)+2
					} else {
						enemy.hpCur -= ((((((2*player.level)/5)+2)*35*(player.atk/enemy.def))/50)+2) * 2
					}
				} else {
					playerToken.entity.position += {offset.x, 0, offset.y}
				}
				player.stCur -= 2
			}
	}
}