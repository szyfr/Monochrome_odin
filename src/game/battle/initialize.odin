package battle


//= Imports
import "core:fmt"
import "core:reflect"

import "vendor:raylib"

import "../../game"
import "../general/camera"
import "../general/audio"
import "../overworld/standee"
import "monsters"


//= Procedures
init :: proc(
	event	: ^game.BattleData,
	wild	: bool = false,
) {
	game.battleStruct = new(game.BattleStructure)
	game.battleStruct.arena		= event.arena

	#partial switch event.arena {
		case .grass:
			camera.move({16,0,61}, 1.25)
	}
	

	configure_player_battle_entity()
	configure_enemy_battle_entity(event, wild)
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
	
	//* Audio
	audio.play_music("new_bark_town")
}

configure_player_battle_entity :: proc() {
	game.battleStruct.playerPokemon.position	= {14,0,60}
	game.battleStruct.playerPokemon.standee		= standee.create(reflect.enum_string(game.player.pokemon[0].species), "pokemon", 2)
	game.battleStruct.playerPokemon.pokemonInfo	= &game.player.pokemon[0]
	game.battleStruct.playerPokemon.canMove		= true
}
configure_enemy_battle_entity :: proc(
	event	: ^game.BattleData,
	wild	: bool,
) {
	game.battleStruct.enemyPokemon.position	= {18,0,60}
	game.battleStruct.enemyPokemon.standee		= standee.create("chikorita", "pokemon", 2)
	game.battleStruct.enemyPokemon.canMove		= true
	game.battleStruct.enemyPokemon.wild			= wild

	game.battleStruct.enemyPokemonList[0] = &event.pokemonNormal[0]
	game.battleStruct.enemyPokemonList[1] = &event.pokemonNormal[1]
	game.battleStruct.enemyPokemonList[2] = &event.pokemonNormal[2]
	game.battleStruct.enemyPokemonList[3] = &event.pokemonNormal[3]
	game.battleStruct.enemyPokemon.pokemonInfo	= &event.pokemonNormal[0]
}