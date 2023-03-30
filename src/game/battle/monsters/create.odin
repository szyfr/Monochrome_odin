package monsters


//= Imports
import "core:fmt"
import "core:encoding/json"
import "core:os"
import "core:math"
import "core:math/rand"
import "core:reflect"

import "../../../game"
import "../../../debug"


//= Procedures
create :: proc(
	species : game.MonsterSpecies,
	level	: int,
) -> game.Pokemon {
	pkmn : game.Pokemon = {}
	pkmn.species	= species
	pkmn.level		= level
	pkmn.experience = exp_needed(level-1)//int(math.pow(f32(level), 3))

	pkmn.nickname = "FUCKFUCKFUCK"

	pkmn.iv[0]		= int(rand.int31_max(30))
	pkmn.iv[1]		= int(rand.int31_max(30))
	pkmn.iv[2]		= int(rand.int31_max(30))
	pkmn.iv[3]		= int(rand.int31_max(30))
	pkmn.iv[4]		= int(rand.int31_max(30))
	pkmn.iv[5]		= int(rand.int31_max(30))

	pokemonData := game.pokemonData[int(species)].(json.Array)
	pkmn.elementalType1, _ = reflect.enum_from_name(game.ElementalType, pokemonData[0].(string))
	pkmn.elementalType2, _ = reflect.enum_from_name(game.ElementalType, pokemonData[1].(string))
	pkmn.hpMax	= calculate_hp(  int(pokemonData[2].(f64)), pkmn.ev[0], pkmn.iv[0], pkmn.level)
	pkmn.hpCur	= pkmn.hpMax
	pkmn.atk	= calculate_stat(int(pokemonData[3].(f64)), pkmn.ev[1], pkmn.iv[1], pkmn.level)
	pkmn.def	= calculate_stat(int(pokemonData[4].(f64)), pkmn.ev[2], pkmn.iv[2], pkmn.level)
	pkmn.spAtk	= calculate_stat(int(pokemonData[5].(f64)), pkmn.ev[3], pkmn.iv[3], pkmn.level)
	pkmn.spDef	= calculate_stat(int(pokemonData[6].(f64)), pkmn.ev[4], pkmn.iv[4], pkmn.level)
	pkmn.spd	= calculate_stat(int(pokemonData[7].(f64)), pkmn.ev[5], pkmn.iv[5], pkmn.level)

	pkmn.size, _ = reflect.enum_from_name(game.Size, pokemonData[8].(string))

	for atk in pokemonData[9].(json.Array) {
		if level >= int(atk.(json.Array)[0].(f64)) {
			attack, _ := reflect.enum_from_name(game.PokemonAttack, atk.(json.Array)[1].(string))
			add_attack(
				&pkmn.attacks,
				attack,
			)
		}
	}

	//delete(rawFile)
	return pkmn
}

calculate_hp :: proc{ calculate_hp_base }
calculate_hp_base :: proc(
	base	: int,
	ev		: int,
	iv		: int,
	level	: int,
) -> int {
	basef, evf, ivf, levelf := f32(base), f32(ev), f32(iv), f32(level)
	return int(math.floor(((4 * basef + ivf + math.floor(evf / 4)) * levelf) / 100) + levelf + 10)
}

calculate_stat :: proc{ calculate_stat_base }
calculate_stat_base :: proc(
	base	: int,
	ev		: int,
	iv		: int,
	level	: int,
	//nature	: game.Nature, //TODO
) -> int {
	basef, evf, ivf, levelf := f32(base), f32(ev), f32(iv), f32(level)
	return int(math.floor(((2 * basef + ivf + math.floor(evf / 4)) * levelf) / 100) + 5)
}

add_attack :: proc(
	atkList : ^[4]game.Attack,
	atk		:  game.PokemonAttack,
) {
	//* Find end
	end := 0
	for i in atkList {
		if i.type == .empty do break
		end += 1
	}

	//* Check if full
	if end > 4 {
		atkList[0].type = atkList[1].type
		atkList[0].cooldown = atkList[1].cooldown
		atkList[1].type = atkList[2].type
		atkList[1].cooldown = atkList[2].cooldown
		atkList[2].type = atkList[3].type
		atkList[2].cooldown = atkList[3].cooldown
		atkList[3].type = atk
		atkList[3].cooldown = 0
	} else do atkList[end].type = atk
}

reset :: proc(
	monster : ^game.Pokemon,
) {
	monster.hpCur = monster.hpMax
}  