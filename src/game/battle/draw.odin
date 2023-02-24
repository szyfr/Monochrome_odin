package battle


//= Imports
import "core:fmt"

import "../../game"
import "../../game/camera"
import "../../game/standee"


//= Procedures
draw :: proc() {
	game.battleStruct.playerPokemon.standee.position[3,0] = game.battleStruct.playerPokemon.position.x + 0.5
	game.battleStruct.playerPokemon.standee.position[3,1] = game.battleStruct.playerPokemon.position.y + 1.0
	game.battleStruct.playerPokemon.standee.position[3,2] = game.battleStruct.playerPokemon.position.z + 0.5
	standee.draw(game.battleStruct.playerPokemon.standee)
}