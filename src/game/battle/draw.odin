package battle


//= Imports
import "core:fmt"

import "../../game"
import "../../game/camera"
import "../../game/standee"
import "../../game/ui"


//= Procedures
draw :: proc() {
	if game.battleStruct.playerPokemon.position.z >= game.battleStruct.enemyPokemon.position.z {
		game.battleStruct.enemyPokemon.standee.position[3,0] = game.battleStruct.enemyPokemon.position.x + 0.5
		game.battleStruct.enemyPokemon.standee.position[3,1] = game.battleStruct.enemyPokemon.position.y + 1.0
		game.battleStruct.enemyPokemon.standee.position[3,2] = game.battleStruct.enemyPokemon.position.z + 0.5
		standee.draw(game.battleStruct.enemyPokemon.standee)

		game.battleStruct.playerPokemon.standee.position[3,0] = game.battleStruct.playerPokemon.position.x + 0.5
		game.battleStruct.playerPokemon.standee.position[3,1] = game.battleStruct.playerPokemon.position.y + 1.0
		game.battleStruct.playerPokemon.standee.position[3,2] = game.battleStruct.playerPokemon.position.z + 0.5
		standee.draw(game.battleStruct.playerPokemon.standee)
	}

	if game.battleStruct.playerPokemon.position.z < game.battleStruct.enemyPokemon.position.z {
		game.battleStruct.playerPokemon.standee.position[3,0] = game.battleStruct.playerPokemon.position.x + 0.5
		game.battleStruct.playerPokemon.standee.position[3,1] = game.battleStruct.playerPokemon.position.y + 1.0
		game.battleStruct.playerPokemon.standee.position[3,2] = game.battleStruct.playerPokemon.position.z + 0.5
		standee.draw(game.battleStruct.playerPokemon.standee)

		game.battleStruct.enemyPokemon.standee.position[3,0] = game.battleStruct.enemyPokemon.position.x + 0.5
		game.battleStruct.enemyPokemon.standee.position[3,1] = game.battleStruct.enemyPokemon.position.y + 1.0
		game.battleStruct.enemyPokemon.standee.position[3,2] = game.battleStruct.enemyPokemon.position.z + 0.5
		standee.draw(game.battleStruct.enemyPokemon.standee)
	}
}