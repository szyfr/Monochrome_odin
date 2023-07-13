package monsters


//= Imports
import "../../game"


//= Procedure
create :: proc{ create_species }
create_species :: proc( species : game.MonsterSpecies, level : int ) -> game.Monster {
	monster : game.Monster

	monster.level = level
	monster.species = species

	#partial switch species {
		case .starter_grass:
			monster.elementalType1 = .grass
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
			monster.attacks[0] = .tackle
			monster.attacks[1] = .growl
			monster.attacks[2] = .leafage
			//monster.attacks[0] = .scratch
			//monster.attacks[1] = .leer
			//monster.attacks[2] = .ember
			//monster.attacks[3] = .aquajet
		case .starter_fire:
			monster.elementalType1 = .fire
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
			monster.attacks[0] = .tackle
			monster.attacks[1] = .leer
			monster.attacks[2] = .ember
		case .starter_water:
			monster.elementalType1 = .water
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
			monster.attacks[0] = .scratch
			monster.attacks[1] = .leer
			monster.attacks[2] = .aquajet
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