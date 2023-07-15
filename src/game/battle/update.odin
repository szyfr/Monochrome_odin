package battle


//= Imports
import "core:fmt"
import "core:math"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../settings"
import "../monsters"
import "../graphics/ui"
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
		playerPos : raylib.Vector2
		if len(game.battleData.moveArrowList) > 0 do playerPos = game.battleData.moveArrowList[len(game.battleData.moveArrowList)-1]
		else do playerPos = {player.entity.position.x-8, player.entity.position.z-55.75}

		difference : raylib.Vector2 = playerPos - game.battleData.target
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

					//* Check new position for hazards
					builder : strings.Builder
					for i:=0;i<game.battleData.enemyHazardCount;i+=1 {
						str := fmt.sbprintf(&builder, "enemy_hazard_%v", i)
						vec := game.battleData.moveArrowList[0]
						hazard, result := game.battleData.field[str]
						if result && hazard.entity.position == {vec.x + 8, 0, vec.y + 55.75} && hazard.type == .hazard {
							// TODO make hazards more adjustable and know more information about their use
						//	player := &game.battleData.playerTeam[game.battleData.currentPlayer]
						//	enemy := &game.battleData.enemyTeam[game.battleData.currentEnemy]
						//	effectiveness := monsters.type_damage_multiplier(.grass, player)
						//	enemy.hpCur -= monsters.calculate_damage(40, f32(enemy.level), modAtk, modDef, effectiveness)
						}
					}

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
						if settings.is_key_pressed("leftclick") {
							if len(game.battleData.moveArrowList) == 0 do use_attack(0)
							else do game.battleData.playerAction = .interaction
						}
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack2:
						if settings.is_key_pressed("leftclick") {
							if len(game.battleData.moveArrowList) == 0 do use_attack(1)
							else do game.battleData.playerAction = .interaction
						}
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack3:
						if settings.is_key_pressed("leftclick") {
							if len(game.battleData.moveArrowList) == 0 do use_attack(2)
							else do game.battleData.playerAction = .interaction
						}
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
					case .attack4:
						if settings.is_key_pressed("leftclick") {
							if len(game.battleData.moveArrowList) == 0 do use_attack(3)
							else do game.battleData.playerAction = .interaction
						}
						if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
				}
				if settings.is_key_pressed("endturn") {
					game.battleData.playersTurn = false
					monsters.start_turn(&game.battleData.enemyTeam[game.battleData.currentEnemy])
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
	attack			:  game.MonsterAttack	= game.battleData.playerTeam[game.battleData.currentPlayer].attacks[value]

	enemy			: ^game.Monster			= &game.battleData.enemyTeam[game.battleData.currentEnemy]
	enemyToken		: ^game.Token			= &game.battleData.field["enemy"]
	enemyPosition	:  raylib.Vector2		= {enemyToken.entity.position.x-8, enemyToken.entity.position.z-55.75}

	player			: ^game.Monster			= &game.battleData.playerTeam[game.battleData.currentPlayer]
	playerToken		: ^game.Token			= &game.battleData.field["player"]
	playerPosition	:  raylib.Vector2		= {playerToken.entity.position.x-8, playerToken.entity.position.z-55.75}

	#partial switch attack {
		case .tackle:
			if player.stCur >= 2 {
				modAtk, modDef : f32

				//* Calculate Attack stat
				if player.statChanges[0] > 0 do modAtk = f32(player.atk) * ((2 + f32(player.statChanges[0])) / 2)
				else do modAtk = f32(player.atk) * (2 / (2 + f32(player.statChanges[0])))
				if modAtk <= 0 do modAtk = 1

				//* Calculate Defense stat
				if enemy.statChanges[1] > 0 do modDef = f32(enemy.def) * ((2 + f32(enemy.statChanges[1])) / 2)
				else do modDef = f32(enemy.def) * (2 / (2 - f32(enemy.statChanges[1])))
				if modDef <= 0 do modDef = 1

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
					effectiveness := type_damage_multiplier(.normal, enemy)
					if spot_empty(enemyPosition + offset) {
						enemyToken.entity.position += {offset.x, 0, offset.y}
						playerToken.entity.position += {offset.x, 0, offset.y}

						enemy.hpCur -= monsters.calculate_damage(35, f32(player.level), modAtk, modDef, effectiveness)
					} else {
						enemy.hpCur -= int(f32(monsters.calculate_damage(40, f32(player.level), modAtk, modDef, effectiveness)) * 1.25)
					}
				} else {
					playerToken.entity.position += {offset.x, 0, offset.y}
				}
				player.stCur -= 2
			}
		case .growl:
			if player.stCur >= 3 {
				difference := playerPosition - enemyPosition
				if (difference.x <= 2 && difference.x >= -2) &&
						(difference.y <= 2 && difference.y >= -2) &&
						!(math.abs(difference.x) == 2 && math.abs(difference.y) == 2) {
					if enemy.statChanges[1] > -6 {
						enemy.statChanges[1] -= 1
						ui.add_message("Defense lowered!")
					} else do ui.add_message("Defense can't go lower!")
				}

				player.stCur -= 3
			}
		case .leafage:
			if player.stCur >= 2 {
				modAtk, modDef : f32

				//* Calculate Special Attack stat
				if player.statChanges[2] > 0 do modAtk = f32(player.spAtk) * ((2 + f32(player.statChanges[2])) / 2)
				else do modAtk = f32(player.spAtk) * (2 / (2 + f32(player.statChanges[3])))
				if modAtk <= 0 do modAtk = 1

				//* Calculate Special Defense stat
				if enemy.statChanges[3] > 0 do modDef = f32(enemy.spDef) * ((2 + f32(enemy.statChanges[3])) / 2)
				else do modDef = f32(enemy.spDef) * (2 / (2 + f32(enemy.statChanges[3])))
				if modDef <= 0 do modDef = 1
				

				if game.battleData.target == enemyPosition {
					effectiveness := type_damage_multiplier(.grass, enemy)
					

					enemy.hpCur -= monsters.calculate_damage(40, f32(player.level), modAtk, modDef, effectiveness)
				} else {
					position : raylib.Vector3 = {game.battleData.target.x+8, 0, game.battleData.target.y+55.75}

					game.battleData.playerHazardCount += 1

					builder : strings.Builder
					str := fmt.sbprintf(&builder, "player_hazard_%v", game.battleData.playerHazardCount)

					game.battleData.field[str] = game.Token{
						overworld.create(position, "starter_fire", "monster")^,
						.hazard,
						modAtk,
					}
				}

				player.stCur -= 4
			}
	}
}

type_damage_multiplier :: proc( type : game.ElementalType, monster : ^game.Monster ) -> f32 {
	output : f32

	weakness : int

	#partial switch type {
		case .normal:
			// TODO Ghost's immunity, Rock + Steel resistance
			//* Resistance
		case .fire:
			// TODO Ice + Bug + Steel weakness, rock + Dragon resistance
			//* Weakness
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness += 1
			//* Resistance
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness -= 1
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness -= 1
		case .water:
			// TODO Ground + Rock Weakness, Dragon resistance
			//* Weakness
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness += 1
			//* Resistance
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness -= 1
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness -= 1
		case .grass:
			// TODO Ground + Rock Weakness, Poison + Flying + Bug + Dragon + Steel resistance
			//* Weakness
			if monster.elementalType1 == .water || monster.elementalType2 == .water do weakness += 1
			//* Resistance
			if monster.elementalType1 == .grass || monster.elementalType2 == .grass do weakness -= 1
			if monster.elementalType1 == .fire || monster.elementalType2 == .fire do weakness -= 1
	}

	switch {
		case weakness >=  3:
			output = 2.5
			ui.add_message("Hyper-Effective!")
		case weakness ==  2:
			output = 2
			ui.add_message("Doubly Super-Effective!")
		case weakness ==  1:
			output = 1.5
			ui.add_message("Super-Effective!")
		case weakness ==  0:
			output = 1
		case weakness == -1:
			output = 0.66
			ui.add_message("Not very effective!")
		case weakness == -2:
			output = 0.5
			ui.add_message("Horribly ineffective!")
		case weakness <= -3:
			output = 0
			ui.add_message("Immune!")
	}

	return output
}