package monsters


//= Imports
import "core:fmt"
import "core:math"
import "core:reflect"
import "core:encoding/json"

import "../../../game"
import "../../general/audio"


//= Procedures
exp_needed :: proc(
	level : int,
) -> int {
	forCur	:= 1.2 * math.pow(f32(level+1), 3) - (15 * math.pow(f32(level+1), 2)) + (100 * f32(level+1)) - 140

	return int(forCur)
}
exp_numbers :: proc(
	level : int,
	experience : int,
) -> (int, int) {
	expNeededLast := exp_needed(level-1)
	expNeededCurr := exp_needed(level)

	return experience - expNeededLast, expNeededCurr - expNeededLast
}

exp_ratio :: proc(
	total : int,
	level : int,
) -> f32 {
	neededCurrentLv := 1.2 * math.pow(f32(level), 3) - (15 * math.pow(f32(level), 2)) + (100 * f32(level)) - 140
	neededNextLv	:= 1.2 * math.pow(f32(level+1), 3) - (15 * math.pow(f32(level+1), 2)) + (100 * f32(level+1)) - 140

	return (f32(total) - neededCurrentLv) / (neededNextLv - neededCurrentLv)
}

number_attacks :: proc(
	attackList : [4]game.Attack,
) -> int {
	res := 0
	for i in attackList {
		if i.type != .empty do res += 1
	}
	return res
}

level_up :: proc(
	monster : ^game.Monster,
) {
	audio.play_sound("level_up")

	monster.level += 1
	monsterData := game.monsterData[int(monster.species)].(json.Array)
	newHPMax	:= calculate_hp(int(monsterData[2].(f64)), monster.ev[0], monster.iv[0], monster.level)
	monster.hpCur	+= newHPMax - monster.hpMax
	monster.hpMax	= newHPMax
	monster.atk	= calculate_stat(int(monsterData[3].(f64)), monster.ev[1], monster.iv[1], monster.level)
	monster.def	= calculate_stat(int(monsterData[4].(f64)), monster.ev[2], monster.iv[2], monster.level)
	monster.spAtk	= calculate_stat(int(monsterData[5].(f64)), monster.ev[3], monster.iv[3], monster.level)
	monster.spDef	= calculate_stat(int(monsterData[6].(f64)), monster.ev[4], monster.iv[4], monster.level)
	monster.spd	= calculate_stat(int(monsterData[7].(f64)), monster.ev[5], monster.iv[5], monster.level)

	for atk in monsterData[9].(json.Array) {
		if monster.level == int(atk.(json.Array)[0].(f64)) {
			attack, _ := reflect.enum_from_name(game.MonsterAttack, atk.(json.Array)[1].(string))
			//TODO Make choice screen
			add_attack(
				&monster.attacks,
				attack,
			)
		}
	}
}

give_experience :: proc(
	monster : ^game.Monster,
	total : int,
) -> bool {
	val := false
	monster.experience += total
	for {
		if monster.experience >= exp_needed(monster.level) {
			level_up(monster)
			val = true
		} else do break
	}

	return val
}