package battle


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../general/camera"
import "../overworld/standee"
import "monsters"


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

	//* Temp
	raylib.StopSound(game.music[game.currentTrack])
	game.currentTrack = "trainer_battle"
	raylib.PlaySound(game.music[game.currentTrack])
	

	configure_player_battle_entity()
	configure_enemy_battle_entity(event)
}

close :: proc() {
	for i in game.battleStruct.enemyPokemonList {
		if i != nil do monsters.reset(i)
	}
	if !game.lastBattleOutcome {
		for i:=0;i<4;i+=1 {
			monsters.reset(&game.player.pokemon[i])
		}
	}

	camera.attach_to_player()
	free(game.battleStruct)
	game.battleStruct = nil
	

	//* Temp
	raylib.StopSound(game.music[game.currentTrack])
	game.currentTrack = "new_bark_town"
	raylib.PlaySound(game.music[game.currentTrack])
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
	game.battleStruct.enemyPokemon.canMove		= true

	game.battleStruct.enemyPokemonList[0] = &event.pokemonNormal[0]
	game.battleStruct.enemyPokemonList[1] = &event.pokemonNormal[1]
	game.battleStruct.enemyPokemonList[2] = &event.pokemonNormal[2]
	game.battleStruct.enemyPokemonList[3] = &event.pokemonNormal[3]
	game.battleStruct.enemyPokemon.pokemonInfo	= &event.pokemonNormal[0]
}