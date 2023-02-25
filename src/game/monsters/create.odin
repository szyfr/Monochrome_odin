package monsters


//= Imports
import "core:math"
import "core:math/rand"

import "../../game"


//= Procedures
create :: proc(
	species : game.PokemonSpecies,
	level	: int,
) -> game.Pokemon {
	pkmn : game.Pokemon = {}
	pkmn.species	= species
	pkmn.level		= level
	pkmn.experience = int(math.pow(f32(level), 3))

	pkmn.iv[0]		= int(rand.int31_max(30))
	pkmn.iv[1]		= int(rand.int31_max(30))
	pkmn.iv[2]		= int(rand.int31_max(30))
	pkmn.iv[3]		= int(rand.int31_max(30))
	pkmn.iv[4]		= int(rand.int31_max(30))
	pkmn.iv[5]		= int(rand.int31_max(30))

	//TODO All of this in the long run
	//TODO Maybe have this in a file?
	#partial switch species {
		case .chikorita:
			pkmn.hpMax	= calculate_hp(  45, pkmn.ev[0], pkmn.iv[0], pkmn.level)
			pkmn.hpCur	= pkmn.hpMax
			pkmn.atk	= calculate_stat(49, pkmn.ev[1], pkmn.iv[1], pkmn.level)
			pkmn.def	= calculate_stat(65, pkmn.ev[2], pkmn.iv[2], pkmn.level)
			pkmn.spAtk	= calculate_stat(49, pkmn.ev[3], pkmn.iv[3], pkmn.level)
			pkmn.spDef	= calculate_stat(65, pkmn.ev[4], pkmn.iv[4], pkmn.level)
			pkmn.spd	= calculate_stat(45, pkmn.ev[5], pkmn.iv[5], pkmn.level)

			pkmn.size = .small

			if level == 5 {
				pkmn.attacks[0] = {.tackle, 0}
				pkmn.attacks[1] = {.growl, 0}
				pkmn.attacks[2] = {.leafage, 0}
			}
			
		case .cyndaquil:
			pkmn.hpMax	= calculate_hp(  39, pkmn.ev[0], pkmn.iv[0], pkmn.level)
			pkmn.hpCur	= pkmn.hpMax
			pkmn.atk	= calculate_stat(52, pkmn.ev[1], pkmn.iv[1], pkmn.level)
			pkmn.def	= calculate_stat(43, pkmn.ev[2], pkmn.iv[2], pkmn.level)
			pkmn.spAtk	= calculate_stat(60, pkmn.ev[3], pkmn.iv[3], pkmn.level)
			pkmn.spDef	= calculate_stat(50, pkmn.ev[4], pkmn.iv[4], pkmn.level)
			pkmn.spd	= calculate_stat(65, pkmn.ev[5], pkmn.iv[5], pkmn.level)

			pkmn.size = .small

			if level == 5 {
				pkmn.attacks[0] = {.tackle, 0}
				pkmn.attacks[1] = {.leer, 0}
				pkmn.attacks[2] = {.ember, 0}
			}
			
		case .totodile:
			pkmn.hpMax	= calculate_hp(  50, pkmn.ev[0], pkmn.iv[0], pkmn.level)
			pkmn.hpCur	= pkmn.hpMax
			pkmn.atk	= calculate_stat(65, pkmn.ev[1], pkmn.iv[1], pkmn.level)
			pkmn.def	= calculate_stat(64, pkmn.ev[2], pkmn.iv[2], pkmn.level)
			pkmn.spAtk	= calculate_stat(44, pkmn.ev[3], pkmn.iv[3], pkmn.level)
			pkmn.spDef	= calculate_stat(48, pkmn.ev[4], pkmn.iv[4], pkmn.level)
			pkmn.spd	= calculate_stat(43, pkmn.ev[5], pkmn.iv[5], pkmn.level)

			pkmn.size = .small

			if level == 5 {
				pkmn.attacks[0] = {.scratch, 0}
				pkmn.attacks[1] = {.growl, 0}
				pkmn.attacks[2] = {.watergun, 0}
			}
	}

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
	return int(math.floor(((2 * basef + ivf + math.floor(evf / 4)) * levelf) / 100) + levelf + 10)
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