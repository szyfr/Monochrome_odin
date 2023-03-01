package monsters


//= Imports
import "core:fmt"
import "core:math"
import "core:reflect"
import "core:encoding/json"

import "../../../game"


//= Procedures
exp_needed :: proc(
	level : int,
) -> int {
	forCur	:= 1.2 * math.pow(f32(level+1), 3) - (15 * math.pow(f32(level+1), 2)) + (100 * f32(level+1)) - 140

	return int(forCur)
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
	pokemon : ^game.Pokemon,
) {
	pokemon.level += 1
	pokemonData := game.pokemonData[int(pokemon.species)].(json.Array)
	newHPMax	:= calculate_hp(int(pokemonData[2].(f64)), pokemon.ev[0], pokemon.iv[0], pokemon.level)
	pokemon.hpCur	+= newHPMax - pokemon.hpMax
	pokemon.hpMax	= newHPMax
	pokemon.atk	= calculate_stat(int(pokemonData[3].(f64)), pokemon.ev[1], pokemon.iv[1], pokemon.level)
	pokemon.def	= calculate_stat(int(pokemonData[4].(f64)), pokemon.ev[2], pokemon.iv[2], pokemon.level)
	pokemon.spAtk	= calculate_stat(int(pokemonData[5].(f64)), pokemon.ev[3], pokemon.iv[3], pokemon.level)
	pokemon.spDef	= calculate_stat(int(pokemonData[6].(f64)), pokemon.ev[4], pokemon.iv[4], pokemon.level)
	pokemon.spd	= calculate_stat(int(pokemonData[7].(f64)), pokemon.ev[5], pokemon.iv[5], pokemon.level)

	for atk in pokemonData[9].(json.Array) {
		if pokemon.level == int(atk.(json.Array)[0].(f64)) {
			attack, _ := reflect.enum_from_name(game.PokemonAttack, atk.(json.Array)[1].(string))
			//TODO Make choice screen
			add_attack(
				&pokemon.attacks,
				attack,
			)
		}
	}
}

give_experience :: proc(
	pokemon : ^game.Pokemon,
	total : int,
) {
	pokemon.experience += total
	for {
		if pokemon.experience >= exp_needed(pokemon.level) do level_up(pokemon)
		else do break
	}
}