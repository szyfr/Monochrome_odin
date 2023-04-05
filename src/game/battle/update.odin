package battle


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"
import "core:math"
import "core:math/linalg"

import "vendor:raylib"

import "../../game"
import "../../game/general/camera"
import "../../game/overworld/standee"
import "../../game/battle/monsters"
import "../../game/battle/enemy_ai"
import "../../game/general/settings"
import "../../game/general/graphics/animations"
import "attacks"


//= Constants
ARENA_MIN_X ::  8
ARENA_MAX_X :: 23
ARENA_MIN_Z :: 55.5
ARENA_MAX_Z :: 62.75

//= Procedures
update :: proc() {
	player	:= &game.battleStruct.playerMonster
	enemy	:= &game.battleStruct.enemyMonster
	pkmn	:=  game.battleStruct.playerMonster.monsterInfo
	
	//* Player movement
	if player.canMove && game.eventmanager.currentEvent == nil {
		upDown    := settings.is_key_down("up")
		downDown  := settings.is_key_down("down")
		leftDown  := settings.is_key_down("left")
		rightDown := settings.is_key_down("right")
		if upDown {
			player.position -= {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
			player.direction = .up
		} else if downDown {
			player.position += {0,0,0.02} * ((f32(pkmn.spd) / 100) + 1)
			player.direction = .down
		}
		if leftDown {
			player.position -= {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)
			player.direction = .left
		} else if rightDown {
			player.position += {0.02,0,0} * ((f32(pkmn.spd) / 100) + 1)
			player.direction = .right
		}
		if !upDown && !downDown && !leftDown && !rightDown {
			dir := reflect.enum_string(player.direction)
			animations.set_animation(&player.standee.animator, strings.concatenate({"idle_", dir}))
		} else {
			dir := reflect.enum_string(player.direction)
			animations.set_animation(&player.standee.animator, strings.concatenate({"walk_", dir}))
		}
	} else if player.forcedMove && game.eventmanager.currentEvent == nil {
		player.position += lerp(player.forcedMoveStart, player.forcedMoveTarget, 0.1, {1,0,1})
	}
	if player.position.x > ARENA_MAX_X do player.position.x = ARENA_MAX_X
	if player.position.x < ARENA_MIN_X do player.position.x = ARENA_MIN_X
	if player.position.z > ARENA_MAX_Z do player.position.z = ARENA_MAX_Z
	if player.position.z < ARENA_MIN_Z do player.position.z = ARENA_MIN_Z

	//* Enemy
	if game.eventmanager.currentEvent == nil {
		enemy_ai.run_ai()
	}
	if enemy.forcedMove {
		enemy.position += lerp(enemy.forcedMoveStart, enemy.forcedMoveTarget, 0.1, {1,0,1})
	}
	if enemy.position.x > ARENA_MAX_X do enemy.position.x = ARENA_MAX_X
	if enemy.position.x < ARENA_MIN_X do enemy.position.x = ARENA_MIN_X
	if enemy.position.z > ARENA_MAX_Z do enemy.position.z = ARENA_MAX_Z
	if enemy.position.z < ARENA_MIN_Z do enemy.position.z = ARENA_MIN_Z

	if enemy.timer < 0 {
		enemy.canMove		= true
		enemy.forcedMove	= false
	} else {
		enemy.timer -= 1
	}


	//* Attack UI
	count	:= monsters.number_attacks(player.monsterInfo.attacks)
	rot		:= 360 - game.battleStruct.playerAttackRot

	interval := f32(360 / count)
	if rot != (f32(player.selectedAtk) * interval) {
		if game.battleStruct.rotationDirect do game.battleStruct.playerAttackRot += 5
		else do game.battleStruct.playerAttackRot -= 5

		if game.battleStruct.playerAttackRot < 0 do game.battleStruct.playerAttackRot = 360
		if game.battleStruct.playerAttackRot > 360 do game.battleStruct.playerAttackRot = 0
	}

	if rot == (f32(player.selectedAtk) * interval) && game.eventmanager.currentEvent == nil {
		if settings.is_key_down("switch_attack_right") {
			if player.selectedAtk == count-1 do player.selectedAtk = 0
			else do player.selectedAtk += 1
			game.battleStruct.rotationDirect = false
		}

		if player.timer < 0 {
			player.canMove		= true
			player.forcedMove	= false
			if settings.is_key_pressed("attack") && player.monsterInfo.attacks[player.selectedAtk].cooldown <= 0 {
				#partial switch player.monsterInfo.attacks[player.selectedAtk].type {
					case .tackle:		attacks.use_tackle(player,enemy,true)
					case .scratch:
					case .growl:		attacks.use_growl(player,enemy,true)
					case .leer:
					case .leafage:
					case .ember:
					case .watergun:
				}
			} else if player.monsterInfo.attacks[player.selectedAtk].cooldown > 0 {
				player.monsterInfo.attacks[player.selectedAtk].cooldown -= 1
			}
		} else {
			player.timer -= 1
		}
	}
	
	//* Boundingbox calcs
	update_bounds(player)
	update_bounds(enemy)

	temp : [dynamic]game.AttackEntity
	for i:=0;i<len(game.battleStruct.attackEntities);i+=1 {

		update_bounds(&game.battleStruct.attackEntities[i])

		switch in game.battleStruct.attackEntities[i] {
			case game.AttackFollow:
				follow := &game.battleStruct.attackEntities[i].(game.AttackFollow)
				//* Player
				if raylib.CheckCollisionBoxes(player.bounds, get_bounds(&game.battleStruct.attackEntities[i])) && !follow.player {
					damage : f32
					switch follow.attackType {
						case .physical:
							damage = (((((2*f32(follow.user.level)) / 5) * follow.power * (f32(follow.user.atk) / f32(enemy.monsterInfo.def))) / 50) + 2)
							if	follow.elementalType == follow.user.elementalType1 || follow.elementalType == follow.user.elementalType2 do damage *= 1.5

							fmt.printf("Player hit for %v damage\n", damage)

							player.canMove			= false
							player.timer			= 20
							player.forcedMove		= true
							player.forcedMoveStart	= player.position
							player.forcedMoveTarget	= player.position + (player.position - follow.target.position)
						case .special:

							fmt.printf("Player hit for %v damage\n", damage)

							player.canMove			= false
							player.timer				= 20
							player.forcedMove		= true
							player.forcedMoveStart	= player.position
							player.forcedMoveTarget	= player.position + (player.position - follow.target.position)
						case .other:
							enemy.timer				= 20
							for i in follow.effects {
								#partial switch i {
									case .atkDown_enemy: player.monsterInfo.statChanges[1] -= 1
									case .atkDown_self: enemy.monsterInfo.statChanges[1] -= 1
								}
							}
					}
					
					damage = math.ceil(damage)
					player.monsterInfo.hpCur -= int(damage)
				}
				//* Enemy
				if raylib.CheckCollisionBoxes(enemy.bounds, get_bounds(&game.battleStruct.attackEntities[i])) && follow.player {
					damage : f32
					switch follow.attackType {
						case .physical:
							damage = (((((2*f32(follow.user.level)) / 5) * follow.power * (f32(follow.user.atk) / f32(enemy.monsterInfo.def))) / 50) + 2)
							if	follow.elementalType == follow.user.elementalType1 || follow.elementalType == follow.user.elementalType2 do damage *= 1.5

							fmt.printf("Enemy hit for %v damage\n", damage)

							enemy.canMove			= false
							enemy.timer				= 20
							enemy.forcedMove		= true
							enemy.forcedMoveStart	= enemy.position
							enemy.forcedMoveTarget	= enemy.position + (enemy.position - follow.target.position)
						case .special:

							fmt.printf("Enemy hit for %v damage\n", damage)

							enemy.canMove			= false
							enemy.timer				= 20
							enemy.forcedMove		= true
							enemy.forcedMoveStart	= enemy.position
							enemy.forcedMoveTarget	= enemy.position + (enemy.position - follow.target.position)
						case .other:
							enemy.timer				= 20
							for i in follow.effects {
								#partial switch i {
									case .atkDown_enemy: enemy.monsterInfo.statChanges[1] -= 1
									case .atkDown_self: player.monsterInfo.statChanges[1] -= 1
								}
							}
					}
					
					damage = math.ceil(damage)
					enemy.monsterInfo.hpCur -= int(damage)
				}
		} 
		
		if update_attack_entity(&game.battleStruct.attackEntities[i]) do append(&temp, game.battleStruct.attackEntities[i])
	}
	delete(game.battleStruct.attackEntities)
	game.battleStruct.attackEntities = temp

	if enemy.monsterInfo.hpCur <= 0 {
		//experience := ((monsters.get_exp_yield(enemy.monsterInfo.species) * f32(enemy.monsterInfo.level)) / 5) * math.pow(((2 * f32(enemy.monsterInfo.level) + 10) / (f32(enemy.monsterInfo.level) + f32(player.monsterInfo.level) + 10)), 2.5) + 1
		experience := ((monsters.get_exp_yield(enemy.monsterInfo.species) * f32(enemy.monsterInfo.level)) / 5)
		if !enemy.wild do experience = f32(experience) * 1.5
		game.battleStruct.experience = int(experience)
		//EXP share
		//Traded
		//Lucky Egg
		//Can evolve by level already
		
		if !enemy.wild && game.eventmanager.currentEvent == nil {
			chn1 := &game.battleTrainerWinEvent.chain[3].(game.GiveExperience)
			chn2 := &game.battleTrainerWinEvent.chain[4].(game.ShowLevelUp)
			chn1.amount = int(experience)
			chn2.level	= player.monsterInfo.level
			chn2.hp		= player.monsterInfo.hpMax
			chn2.atk	= player.monsterInfo.atk
			chn2.def	= player.monsterInfo.def
			chn2.spatk	= player.monsterInfo.spAtk
			chn2.spdef	= player.monsterInfo.spDef
			chn2.spd	= player.monsterInfo.spd
			game.eventmanager.currentEvent = &game.battleTrainerWinEvent
		} else if enemy.wild && game.eventmanager.currentEvent == nil {
			chn1 := &game.battleWildWinEvent.chain[3].(game.GiveExperience)
			chn2 := &game.battleWildWinEvent.chain[4].(game.ShowLevelUp)
			chn1.amount	= int(experience)
			chn2.level	= player.monsterInfo.level
			chn2.hp		= player.monsterInfo.hpMax
			chn2.atk	= player.monsterInfo.atk
			chn2.def	= player.monsterInfo.def
			chn2.spatk	= player.monsterInfo.spAtk
			chn2.spdef	= player.monsterInfo.spDef
			chn2.spd	= player.monsterInfo.spd
			game.eventmanager.currentEvent = &game.battleWildWinEvent
		}
		//switch
		game.lastBattleOutcome = true
		return
	}
	if player.monsterInfo.hpCur <= 0 {
		//switch
		game.lastBattleOutcome = false
		close()
		return
	}
	

	if settings.is_key_pressed("debug") {
		fmt.printf("%v/%v\n",player.monsterInfo.experience,monsters.exp_needed(player.monsterInfo.level))
	}
}

update_bounds :: proc{ update_bounds_battle_entity, update_bounds_attack_entity,  }
update_bounds_battle_entity :: proc(
	ent : ^game.BattleEntity,
) {
	switch ent.monsterInfo.size {
		case .small:
			ent.bounds = {
				{ent.position.x, 0, ent.position.z},
				{ent.position.x + 1, +1, ent.position.z + 1.25},
			}
		case .medium:
			ent.bounds = {
				{ent.position.x - 0.25, 0, ent.position.z - 0.25},
				{ent.position.x + 1.25, 1, ent.position.z + 1.50},
			}
		case .large:
			ent.bounds = {
				{ent.position.x - 0.5, 0, ent.position.z - 0.50},
				{ent.position.x + 1.5, 1, ent.position.z + 1.75},
			}
	}
	if !ent.canMove do ent.bounds = {}
}
update_bounds_attack_entity :: proc(
	ent : ^game.AttackEntity,
) {
	#partial switch in ent {
		case game.AttackFollow:
			follow := &ent.(game.AttackFollow)
			position := ent.(game.AttackFollow).target.position + {0.5,0.03,0.5}
			follow.bounds = {
				{
					position.x - ent.(game.AttackFollow).boundsSize.x/2,
					position.y - ent.(game.AttackFollow).boundsSize.y/2,
					position.z - ent.(game.AttackFollow).boundsSize.z/2,
				},
				{
					position.x + ent.(game.AttackFollow).boundsSize.x/2,
					position.y + ent.(game.AttackFollow).boundsSize.y/2,
					position.z + ent.(game.AttackFollow).boundsSize.z/2,
				},
			}
	}
}

update_attack_entity :: proc(
	ent : ^game.AttackEntity,
) -> bool {
	#partial switch in ent {
		case game.AttackFollow:
			follow := &ent.(game.AttackFollow)
			follow.life -= 1
			if follow.life <= 0 do return false
			return true
	}
	return false
}

get_bounds :: proc{ get_bounds_battle_entity, get_bounds_attack_entity, }
get_bounds_battle_entity :: proc(
	ent : ^game.BattleEntity,
) -> raylib.BoundingBox {
	bounds : raylib.BoundingBox
	switch ent.monsterInfo.size {
		case .small:
			bounds = {
				{ent.position.x, 0, ent.position.z},
				{ent.position.x + 1, +1, ent.position.z + 1.25},
			}
		case .medium:
			bounds = {
				{ent.position.x - 0.25, 0, ent.position.z - 0.25},
				{ent.position.x + 1.25, 1, ent.position.z + 1.50},
			}
		case .large:
			bounds = {
				{ent.position.x - 0.5, 0, ent.position.z - 0.50},
				{ent.position.x + 1.5, 1, ent.position.z + 1.75},
			}
	}
	return bounds
}
get_bounds_attack_entity :: proc(
	ent : ^game.AttackEntity,
) -> raylib.BoundingBox {
	bounds : raylib.BoundingBox
	#partial switch in ent {
		case game.AttackFollow:
			position := ent.(game.AttackFollow).target.position + {0.5,0.03,1}
			bounds = {
				{
					position.x - ent.(game.AttackFollow).boundsSize.x/2,
					position.y - ent.(game.AttackFollow).boundsSize.y/2,
					position.z - ent.(game.AttackFollow).boundsSize.z/2,
				},
				{
					position.x + ent.(game.AttackFollow).boundsSize.x/2,
					position.y + ent.(game.AttackFollow).boundsSize.y/2,
					position.z + ent.(game.AttackFollow).boundsSize.z/2,
				},
			}
			//bounds = ent.(game.AttackFollow).bounds
	}
	return bounds
}

lerp :: proc(
	start, end	: raylib.Vector3,
	percentage	: f32 = 0.1,
	scale		: raylib.Vector3 = {1,1,1},
) -> raylib.Vector3 {
	return (linalg.vector_normalize((end - start)) * percentage) * scale
}