package battle


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"
import "../../game/camera"
import "../../game/standee"
import "../../game/ui"


//= Procedures
draw :: proc() {
	ray := raylib.GetMouseRay(raylib.GetMousePosition(), game.camera)
	col := raylib.GetRayCollisionBox(ray, {{8,0,56}, {24,0,64}})
	game.battleStruct.playerTarget = col.point
	color := raylib.WHITE
	if !col.hit {
		color = {0,0,0,64}
	}
	raylib.DrawModel(
		game.targeter,
		col.point + {0,0.01,0},
		1,
		color,
	)

	if game.battleStruct.playerPokemon.position.z >= game.battleStruct.enemyPokemon.position.z {
		game.battleStruct.enemyPokemon.standee.position[3,0] = game.battleStruct.enemyPokemon.position.x + 0.5
		game.battleStruct.enemyPokemon.standee.position[3,1] = game.battleStruct.enemyPokemon.position.y + 1.0
		game.battleStruct.enemyPokemon.standee.position[3,2] = game.battleStruct.enemyPokemon.position.z + 0.5
		raylib.DrawBoundingBox(game.battleStruct.enemyPokemon.bounds, raylib.PURPLE)
		standee.draw(game.battleStruct.enemyPokemon.standee)

		game.battleStruct.playerPokemon.standee.position[3,0] = game.battleStruct.playerPokemon.position.x + 0.5
		game.battleStruct.playerPokemon.standee.position[3,1] = game.battleStruct.playerPokemon.position.y + 1.0
		game.battleStruct.playerPokemon.standee.position[3,2] = game.battleStruct.playerPokemon.position.z + 0.5
		raylib.DrawBoundingBox(game.battleStruct.playerPokemon.bounds, raylib.PURPLE)
		standee.draw(game.battleStruct.playerPokemon.standee)
	}

	if game.battleStruct.playerPokemon.position.z < game.battleStruct.enemyPokemon.position.z {
		game.battleStruct.playerPokemon.standee.position[3,0] = game.battleStruct.playerPokemon.position.x + 0.5
		game.battleStruct.playerPokemon.standee.position[3,1] = game.battleStruct.playerPokemon.position.y + 1.0
		game.battleStruct.playerPokemon.standee.position[3,2] = game.battleStruct.playerPokemon.position.z + 0.5
		raylib.DrawBoundingBox(game.battleStruct.playerPokemon.bounds, raylib.PURPLE)
		standee.draw(game.battleStruct.playerPokemon.standee)

		game.battleStruct.enemyPokemon.standee.position[3,0] = game.battleStruct.enemyPokemon.position.x + 0.5
		game.battleStruct.enemyPokemon.standee.position[3,1] = game.battleStruct.enemyPokemon.position.y + 1.0
		game.battleStruct.enemyPokemon.standee.position[3,2] = game.battleStruct.enemyPokemon.position.z + 0.5
		raylib.DrawBoundingBox(game.battleStruct.enemyPokemon.bounds, raylib.PURPLE)
		standee.draw(game.battleStruct.enemyPokemon.standee)
	}
}