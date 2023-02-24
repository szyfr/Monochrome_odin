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
	pkmn.experience = int(math.pow(f32(level), 3))

	//TODO All of this in the long run
	//TODO Maybe have this in a file?
	#partial switch species {
		case .chikorita:
			pkmn.spd = 10
			if level == 5 {
				pkmn.attacks[0] = .tackle
				pkmn.attacks[1] = .growl
				pkmn.attacks[2] = .leafage
			}
			
		case .cyndaquil:
			if level == 5 {
				pkmn.attacks[0] = .tackle
				pkmn.attacks[1] = .leer
				pkmn.attacks[2] = .ember
			}
			
		case .totodile:
			if level == 5 {
				pkmn.attacks[0] = .scratch
				pkmn.attacks[1] = .growl
				pkmn.attacks[2] = .watergun
			}
	}

	return pkmn
}