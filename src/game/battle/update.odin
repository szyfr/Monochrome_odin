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
import "../../game/general/settings"
import "../../game/general/graphics/animations"


//= Constants
ARENA_MIN_X ::  8
ARENA_MAX_X :: 23
ARENA_MIN_Z :: 55.5
ARENA_MAX_Z :: 62.75

//= Procedures
update :: proc() {
	player	:= &game.battleStruct.playerPokemon
	enemy	:= &game.battleStruct.enemyPokemon
	pkmn	:=  game.battleStruct.playerPokemon.pokemonInfo
	
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

	//* Enemy movement
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
	count	:= monsters.number_attacks(player.pokemonInfo.attacks)
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
			if settings.is_key_pressed("attack") && player.pokemonInfo.attacks[player.selectedAtk].cooldown <= 0 {
				#partial switch player.pokemonInfo.attacks[player.selectedAtk].type {
					case .tackle:
						player.canMove = false
						player.timer = 15

						player.forcedMove		= true
						player.forcedMoveTarget	= game.battleStruct.playerTarget
						player.forcedMoveStart	= player.position + {0.5,0.02,1}

						angle : f32 = -math.atan2(
							(player.forcedMoveTarget.z - 1) - player.forcedMoveStart.z,
							(player.forcedMoveTarget.x - 0.5) - player.forcedMoveStart.x,
						) * (180 / math.PI)
						if angle <=  120 && angle >   60 do player.direction = .up
						if angle <=   60 && angle >  -60 do player.direction = .right
						if angle <=  -60 && angle > -120 do player.direction = .down
						if (angle <= -120 && angle > -180) || (angle <= 180 && angle > 120) do player.direction = .left
						dir := reflect.enum_string(player.direction)
						animations.set_animation(&player.standee.animator, strings.concatenate({"walk_", dir}))

						player.pokemonInfo.attacks[player.selectedAtk].cooldown = 100

						ent : game.AttackFollow = {
							player,
							player.bounds,

							.physical,
							.normal,
							40,

							15,
							player.pokemonInfo,
							true,
						}
						append(&game.battleStruct.attackEntities, ent)
	
					case .scratch:
					case .growl:
					case .leer:
					case .leafage:
					case .ember:
					case .watergun:
				}
			} else if player.pokemonInfo.attacks[player.selectedAtk].cooldown > 0 {
				player.pokemonInfo.attacks[player.selectedAtk].cooldown -= 1
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
					fmt.printf("player hit by enemy\n")
				}
				//* Enemy
				if raylib.CheckCollisionBoxes(enemy.bounds, get_bounds(&game.battleStruct.attackEntities[i])) && follow.player {
					enemy.canMove			= false
					enemy.timer				= 20
					enemy.forcedMove		= true
					enemy.forcedMoveStart	= enemy.position
					enemy.forcedMoveTarget	= enemy.position + (enemy.position - follow.target.position)
					
					damage : f32
					switch follow.attackType {
						case .physical:
							damage = (((((2*f32(follow.user.level)) / 5) * follow.power * (f32(follow.user.atk) / f32(enemy.pokemonInfo.def))) / 50) + 2)
							if	follow.elementalType == follow.user.elementalType1 || follow.elementalType == follow.user.elementalType2 do damage *= 1.5
						case .special:
						case .other:
					}
					
					damage = math.ceil(damage)
					enemy.pokemonInfo.hpCur -= int(damage)
					fmt.printf("Enemy hit for %v damage\n", damage)
				}
		} 
		
		if update_attack_entity(&game.battleStruct.attackEntities[i]) do append(&temp, game.battleStruct.attackEntities[i])
	}
	delete(game.battleStruct.attackEntities)
	game.battleStruct.attackEntities = temp

	if enemy.pokemonInfo.hpCur <= 0 {
		//experience := ((monsters.get_exp_yield(enemy.pokemonInfo.species) * f32(enemy.pokemonInfo.level)) / 5) * math.pow(((2 * f32(enemy.pokemonInfo.level) + 10) / (f32(enemy.pokemonInfo.level) + f32(player.pokemonInfo.level) + 10)), 2.5) + 1
		experience := ((monsters.get_exp_yield(enemy.pokemonInfo.species) * f32(enemy.pokemonInfo.level)) / 5)
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
			chn2.level	= player.pokemonInfo.level
			chn2.hp		= player.pokemonInfo.hpMax
			chn2.atk	= player.pokemonInfo.atk
			chn2.def	= player.pokemonInfo.def
			chn2.spatk	= player.pokemonInfo.spAtk
			chn2.spdef	= player.pokemonInfo.spDef
			chn2.spd	= player.pokemonInfo.spd
			game.eventmanager.currentEvent = &game.battleTrainerWinEvent
		} else if enemy.wild && game.eventmanager.currentEvent == nil {
			chn1 := &game.battleWildWinEvent.chain[3].(game.GiveExperience)
			chn2 := &game.battleWildWinEvent.chain[4].(game.ShowLevelUp)
			chn1.amount	= int(experience)
			chn2.level	= player.pokemonInfo.level
			chn2.hp		= player.pokemonInfo.hpMax
			chn2.atk	= player.pokemonInfo.atk
			chn2.def	= player.pokemonInfo.def
			chn2.spatk	= player.pokemonInfo.spAtk
			chn2.spdef	= player.pokemonInfo.spDef
			chn2.spd	= player.pokemonInfo.spd
			game.eventmanager.currentEvent = &game.battleWildWinEvent
		}
		//switch
		game.lastBattleOutcome = true
		return
	}
	if player.pokemonInfo.hpCur <= 0 {
		//switch
		game.lastBattleOutcome = false
		close()
		return
	}
	

	if settings.is_key_pressed("debug") {
		fmt.printf("%v/%v\n",player.pokemonInfo.experience,monsters.exp_needed(player.pokemonInfo.level))
	}
}

update_bounds :: proc{ update_bounds_battle_entity, update_bounds_attack_entity,  }
update_bounds_battle_entity :: proc(
	ent : ^game.BattleEntity,
) {
	switch ent.pokemonInfo.size {
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
			follow.bounds = get_bounds_battle_entity(follow.target)
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
	switch ent.pokemonInfo.size {
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
			bounds = ent.(game.AttackFollow).bounds
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