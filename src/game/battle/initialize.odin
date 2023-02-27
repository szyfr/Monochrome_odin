package battle


//= Imports
import "core:fmt"

import "../../game"
import "../general/camera"
import "../overworld/standee"


//= Procedures
init :: proc(
	event : ^game.BattleData,
) {
	game.battleStruct = new(game.BattleStructure)
	game.battleStruct.arena		= event.arena

	#partial switch event.arena {
		case .grass:
			camera.move({16,0,61}, 1.25)
	}
	

	configure_player_battle_entity()
	configure_enemy_battle_entity(event)
}

close :: proc() {
	camera.attach_to_player()
	free(game.battleStruct)
	game.battleStruct = nil
}

configure_player_battle_entity :: proc() {
	game.battleStruct.playerPokemon.position	= {14,0,60}
	game.battleStruct.playerPokemon.standee		= standee.create("chikorita", 2)
	game.battleStruct.playerPokemon.pokemonInfo	= &game.player.pokemon[0]
	game.battleStruct.playerPokemon.canMove		= true
}
configure_enemy_battle_entity :: proc(
	event : ^game.BattleData,
) {
	game.battleStruct.enemyPokemon.position	= {18,0,60}
	game.battleStruct.enemyPokemon.standee		= standee.create("chikorita", 2)
	game.battleStruct.enemyPokemon.pokemonInfo	= &event.pokemonNormal[0]
	game.battleStruct.enemyPokemon.canMove		= true
}