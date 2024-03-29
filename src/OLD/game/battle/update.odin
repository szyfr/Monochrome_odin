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
	if game.battleData != nil && game.eventmanager.currentEvent == nil {
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
		// TODO Simplify this
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
		
		//if len(game.battleData.events) == 0 {
		if game.battleData.event == nil {
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
						//game.battleData.movementTimer = 10
						playerToken := &game.battleData.field["player"]
						vec := game.battleData.moveArrowList[0]
						//ply.entity.position = {vec.x + 8, 0, vec.y + 55.75}
						direction : game.Direction = calc_direction(playerToken.entity.position, raylib.Vector3{vec.x + 8, 0, vec.y + 55.75})
						move_monster(playerToken, direction)

						//* Check new position for hazards
						builder : strings.Builder
						for i:=0;i<game.battleData.enemyHazardCount;i+=1 {
							str := fmt.sbprintf(&builder, "enemy_hazard_%v", i)
							vec := game.battleData.moveArrowList[0]
							hazard, result := game.battleData.field[str]
							if result && hazard.entity.position == {vec.x + 8, 0, vec.y + 55.75} && hazard.type == .hazard {
								player := &game.battleData.playerTeam[game.battleData.currentPlayer]
								data := hazard.data.(game.AttackData)
								if data.user != player {
									if activate_hazard(false, data) do delete_key(&game.battleData.field, str)
								}
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
								if len(game.battleData.moveArrowList) == 0 do use_attack(true, 0)
								else do game.battleData.playerAction = .interaction
							}
							if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
						case .attack2:
							if settings.is_key_pressed("leftclick") {
								if len(game.battleData.moveArrowList) == 0 do use_attack(true, 1)
								else do game.battleData.playerAction = .interaction
							}
							if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
						case .attack3:
							if settings.is_key_pressed("leftclick") {
								if len(game.battleData.moveArrowList) == 0 do use_attack(true, 2)
								else do game.battleData.playerAction = .interaction
							}
							if settings.is_key_pressed("rightclick") do game.battleData.playerAction = .interaction
						case .attack4:
							if settings.is_key_pressed("leftclick") {
								if len(game.battleData.moveArrowList) == 0 do use_attack(true, 3)
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
				process_turn()
			//	enemy_AI()
				game.battleData.playersTurn = true
				monsters.start_turn(&game.battleData.playerTeam[game.battleData.currentPlayer])
			}

			//* Checking for win
			enemyMon	:= &game.battleData.enemyTeam[game.battleData.currentEnemy]
			playerMon	:= &game.battleData.playerTeam[game.battleData.currentPlayer]
			if enemyMon.hpCur <= 0 {
				//* Check for other monsters
				//* End battle
				//TODO Move this around so that once you defeat an enemy it gives experience, *then* check for other monsters, *then* end battle
				game.eventmanager.currentEvent = &game.region.events["trainer_battle_win"]
				totalExp := monsters.calculate_experience_gain(enemyMon)

				exper := &game.eventmanager.currentEvent.chain[3].(game.GiveExperience)
				game.battleData.experience += totalExp
				exper.amount = game.battleData.experience
				exper.member = game.battleData.currentPlayer

				if playerMon.experience + game.battleData.experience >= monsters.calculate_experience(playerMon.level+1, playerMon.rate) {
					game.eventmanager.currentEvent.chain[4] = game.ShowLevelUp{
						level	= playerMon.level,
						hp		= playerMon.hpMax,
						st		= playerMon.stMax,
						atk		= playerMon.atk,
						def		= playerMon.def,
						spatk	= playerMon.spAtk,
						spdef	= playerMon.spDef,
						spd		= playerMon.spd,
					}
				} else {
					game.eventmanager.currentEvent.chain[4] = game.WaitEvent{0}
				}
			}
			//* Checking for loss
		} else {
			//switch event in game.battleData.events[0] {
			switch event in game.battleData.event {
				case game.DamageMonster:
					if event.remainder != game.battleData.counter {
						game.battleData.counter += 1
						event.monster.hpCur -= 1
					} else {
						game.battleData.event = nil
					//	undercut_events()
						game.battleData.counter = 0
					}
				case game.MoveMonster:
					offset : raylib.Vector3
					switch event.direction {
						case .right:	event.monster.entity.position += { 0.1, 0.0,  0.0}
						case .left:		event.monster.entity.position += {-0.1, 0.0,  0.0}
						case .down:		event.monster.entity.position += { 0.0, 0.0,  1.0}
						case .up:		event.monster.entity.position += { 0.0, 0.0, -1.0}
					}
					if close_enough(event.monster.entity.position, event.target) {
						event.monster.entity.position = event.target
					//	undercut_events()
						game.battleData.event = nil
					}
				case game.UseAttack:
			}
		}
	}
}

//undercut_events :: proc() {
//	temp : [dynamic]game.BattleEvent
//
//	for i:=1;i<len(game.battleData.events);i+=1 {
//		append(&temp, game.battleData.events[i])
//	}
//	delete(game.battleData.events)
//	game.battleData.events = temp
//	delete(temp)
//}

damage_monster :: proc( monster : ^game.Monster, damage : int ) {
	game.battleData.event = game.DamageMonster{ monster, damage }
//	fmt.printf("Damage\n")
//	append(&game.battleData.events, game.DamageMonster{ monster, damage })
}
move_monster :: proc( monster : ^game.Token, direction : game.Direction ) {
	offset : raylib.Vector3
	switch direction {
		case .right:	offset = { 1, 0,  0}
		case .left:		offset = {-1, 0,  0}
		case .down:		offset = { 0, 0,  1}
		case .up:		offset = { 0, 0, -1}
	}
	fmt.printf("Move\n")

	game.battleData.event = game.MoveMonster{ monster, direction, monster.entity.position + offset }
//	append(&game.battleData.events, game.MoveMonster{ monster, direction, monster.entity.position + offset })
}

undercut_arrow :: proc() {
	temp : [dynamic]raylib.Vector2

	for i:=1;i<len(game.battleData.moveArrowList);i+=1 {
		append(&temp, game.battleData.moveArrowList[i])
	}
	delete(game.battleData.moveArrowList)
	game.battleData.moveArrowList = temp
}

type_damage_multiplier :: proc( type : game.ElementalType, monster : ^game.Monster, showui : bool = true ) -> f32 {
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
			if showui do ui.add_message("Hyper-Effective!")
		case weakness ==  2:
			output = 2
			if showui do ui.add_message("Doubly Super-Effective!")
		case weakness ==  1:
			output = 1.5
			if showui do ui.add_message("Super-Effective!")
		case weakness ==  0:
			output = 1
		case weakness == -1:
			output = 0.66
			if showui do ui.add_message("Not very effective!")
		case weakness == -2:
			output = 0.33
			if showui do ui.add_message("Horribly ineffective!")
		case weakness <= -3:
			output = 0
			if showui do ui.add_message("Immune!")
	}

	return output
}

calc_direction :: proc{ calc_direction_v3, calc_direction_v2 }
calc_direction_v3 :: proc( p1,p2 : raylib.Vector3 ) -> game.Direction {
	distance := dist(p1, p2)
	direction : game.Direction

	if distance > dist(p1 + { 1, 0, 0}, p2) do direction = .right
	if distance > dist(p1 + {-1, 0, 0}, p2) do direction = .left
	if distance > dist(p1 + { 0, 0, 1}, p2) do direction = .down
	if distance > dist(p1 + { 0, 0,-1}, p2) do direction = .up

	return direction
}
calc_direction_v2 :: proc( p1,p2 : raylib.Vector2 ) -> game.Direction {
	distance := dist(p1, p2)
	direction : game.Direction

	if distance > dist(p1 + { 1, 0}, p2) do direction = .right
	if distance > dist(p1 + {-1, 0}, p2) do direction = .left
	if distance > dist(p1 + { 0, 1}, p2) do direction = .down
	if distance > dist(p1 + { 0,-1}, p2) do direction = .up

	return direction
}