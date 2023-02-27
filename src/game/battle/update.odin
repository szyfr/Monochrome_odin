package battle


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"
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
	
	if player.canMove {
		//* Player Position
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
	} else if player.forcedMove {
		player.position += (linalg.vector_normalize((player.forcedMoveTarget - player.forcedMoveStart)) * 0.1) * {1,0,1}
	}
	if player.position.x > ARENA_MAX_X do player.position.x = ARENA_MAX_X
	if player.position.x < ARENA_MIN_X do player.position.x = ARENA_MIN_X
	if player.position.z > ARENA_MAX_Z do player.position.z = ARENA_MAX_Z
	if player.position.z < ARENA_MIN_Z do player.position.z = ARENA_MIN_Z


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

	if rot == (f32(player.selectedAtk) * interval) {
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

						player.pokemonInfo.attacks[player.selectedAtk].cooldown = 100

						ent : game.AttackFollow = {
							player,
							player.bounds,
							15,
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
					fmt.printf("enemy hit by player\n")
					//Knockback
					enemy.canMove = false
					enemy.timer = 10
				}
		} 
		

		

		if update_attack_entity(&game.battleStruct.attackEntities[i]) do append(&temp, game.battleStruct.attackEntities[i])
	}
	delete(game.battleStruct.attackEntities)
	game.battleStruct.attackEntities = temp
	

	if settings.is_key_pressed("debug") {
		for i in game.battleStruct.attackEntities {
			fmt.printf("%v\n",i)
		}
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