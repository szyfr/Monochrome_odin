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

			monster.ai.type = .tank_setup
			monster.ai.aggression = 5
			monster.ai.special = 3
		case .starter_fire:
			monster.elementalType1 = .fire
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
			monster.attacks[0] = .tackle
			monster.attacks[1] = .leer
			monster.attacks[2] = .ember

			monster.ai.type = .ranged_special
			monster.ai.aggression = 8
			monster.ai.special = 1
		case .starter_water:
			monster.elementalType1 = .water
			monster.elementalType2 = .none
			monster.size = .small
			monster.rate = .medium
			monster.attacks[0] = .scratch
			monster.attacks[1] = .leer
			monster.attacks[2] = .aquajet

			monster.ai.type = .brawler_physical
			monster.ai.aggression = 10
			monster.ai.special = 0
	}
	
	update_stats(&monster)
	monster.experience = calculate_experience(monster.level, monster.rate)
	init_brain(&monster)

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

init_brain :: proc( monster : ^game.Monster ) {
	brain := &monster.ai
	for i in 0..<4 {
		#partial switch monster.attacks[i] {
			case .tackle:
				brain.attack[i].attack		= .tackle
				brain.attack[i].type		= .normal
				brain.attack[i].category	= .physical
				brain.attack[i].damage		= 40
				brain.attack[i].range		= 1
				brain.attack[i].aggression	= 10
				brain.attack[i].stCost		= 2
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= true
			case .scratch:
				brain.attack[i].attack		= .scratch
				brain.attack[i].type		= .normal
				brain.attack[i].category	= .physical
				brain.attack[i].damage		= 40
				brain.attack[i].range		= 1
				brain.attack[i].aggression	= 10
				brain.attack[i].stCost		= 2
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= true
			case .growl:
				brain.attack[i].attack		= .growl
				brain.attack[i].type		= .normal
				brain.attack[i].category	= .other
				brain.attack[i].damage		= 0
				brain.attack[i].range		= 2
				brain.attack[i].aggression	= 4
				brain.attack[i].stCost		= 3
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= false
			case .leer:
				brain.attack[i].attack		= .leer
				brain.attack[i].type		= .normal
				brain.attack[i].category	= .other
				brain.attack[i].damage		= 0
				brain.attack[i].range		= 3
				brain.attack[i].aggression	= 3
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= false
			case .leafage:
				brain.attack[i].attack		= .leafage
				brain.attack[i].type		= .grass
				brain.attack[i].category	= .special
				brain.attack[i].damage		= 40
				brain.attack[i].range		= -1
				brain.attack[i].aggression	= 4
				brain.attack[i].stCost		= 4
				brain.attack[i].needEnemy	= false
				brain.attack[i].damaging	= true
			case .ember:
				brain.attack[i].attack		= .ember
				brain.attack[i].type		= .fire
				brain.attack[i].category	= .special
				brain.attack[i].damage		= 35
				brain.attack[i].range		= 5
				brain.attack[i].aggression	= 10
				brain.attack[i].stCost		= 3
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= true
			case .aquajet:
				brain.attack[i].attack		= .aquajet
				brain.attack[i].type		= .water
				brain.attack[i].category	= .physical
				brain.attack[i].damage		= 35
				brain.attack[i].range		= 3
				brain.attack[i].aggression	= 10
				brain.attack[i].stCost		= 3
				brain.attack[i].needEnemy	= true
				brain.attack[i].damaging	= true
		}
	}
}