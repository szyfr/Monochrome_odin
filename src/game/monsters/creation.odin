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
			monster.attacks[0] = .tackle
			monster.attacks[1] = .growl
			monster.attacks[2] = .leafage
		case .starter_fire:
		case .starter_water:
	}

	update_stats(&monster)
	monster.experience = calculate_experience(monster.level, monster.rate)

	return monster
}

add_to_team :: proc( species : game.MonsterSpecies, level : int ) -> bool {
	//* Check if there's any empty spots on team
	hasSpot := false
	openSpot : int
	for i in 0..<4 {
		if game.player.monsters[i].species == .empty {
			//* Find earliest open spot
			openSpot = i
			hasSpot = true
			break
		}
	}
	if !hasSpot do return false
	
	//* create monster
	game.player.monsters[openSpot] = create(species, level)
	
	return true
}