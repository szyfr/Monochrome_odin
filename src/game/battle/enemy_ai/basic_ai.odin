package enemy_ai


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../../game"
import "../attacks"


//= Procedures
run_ai :: proc() {
	switch game.battleStruct.enemyPokemon.enemyAi {
		case .physical_close_range: physical_close_range_ai()
	}
}

physical_close_range_ai :: proc() {
	player	:= &game.battleStruct.playerPokemon
	enemy	:= &game.battleStruct.enemyPokemon

	enemy.target = player.position + {0.5,0.02,1}

	attacking := 4
	for i in 0..<4 {
		#partial switch enemy.pokemonInfo.attacks[i].type {
			case .tackle:
				if enemy.pokemonInfo.attacks[i].cooldown <= 0 {
					if distance(enemy.position + {0.5,0.02,1}, enemy.target) <= 3 {
						attacks.use_tackle(enemy, player, false)
					} else if enemy.canMove {
						movement : raylib.Vector3
						if player.position.x > enemy.position.x do movement.x =  0.02 * ((f32(enemy.pokemonInfo.spd) / 100) + 1)
						if player.position.x < enemy.position.x do movement.x = -0.02 * ((f32(enemy.pokemonInfo.spd) / 100) + 1)
						if player.position.z > enemy.position.z do movement.z =  0.02 * ((f32(enemy.pokemonInfo.spd) / 100) + 1)
						if player.position.z < enemy.position.z do movement.z = -0.02 * ((f32(enemy.pokemonInfo.spd) / 100) + 1)
						enemy.position += movement
					}
				} else do enemy.pokemonInfo.attacks[i].cooldown -= 1
			case .scratch:

			case .growl:
			case .leer:

			case .leafage:
			case .ember:
			case .watergun:
		}
	}
}

distance :: proc(
	v0,v1 : raylib.Vector3,
) -> f32 {
	//fmt.printf(
	//	"(%v-%v)^2 + (%v-%v)^2 + (%v-%v)^2\n %v + %v + %v = %v",
	//	v1.x, v0.
	//)
	return math.sqrt( math.pow(v1.x - v0.x, 2) + math.pow(v1.y - v0.y, 2) + math.pow(v1.z - v0.z, 2) )
}