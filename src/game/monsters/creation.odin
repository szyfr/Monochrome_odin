package monsters


//= Imports
import "../../game"


//= Procedure
create :: proc{ create_species }
create_species :: proc( species : game.MonsterSpecies, level : int ) -> game.Monster {
	monster : game.Monster

	monster.level = level


	#partial switch species {
		case .starter_grass:
			monster.species = species
			monster.elementalType1 = .grass
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
		case .starter_fire:
		case .starter_water:
	}

	update_stats(&monster)

	return monster
}

