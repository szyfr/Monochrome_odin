package battle


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures

arrow_pressed :: proc() {
	playerPos : raylib.Vector2 = {game.battleData.field["player"].entity.position.x - 8, game.battleData.field["player"].entity.position.z - 55.75}
	
	//* Delete Previous path
	if len(game.battleData.moveArrowList) > 0 {
		delete(game.battleData.moveArrowList)
		game.battleData.moveArrowList = make([dynamic]raylib.Vector2)
	}

	//* Check if player is drawing path
	if game.battleData.target == playerPos do game.battleData.moveArrowDraw = true
	else {
		//* Else, auto path if empty space
		if spot_empty(game.battleData.target) do calculate_path()
	}
}

arrow_down :: proc() {
	if game.battleData.moveArrowDraw {

	}
}
arrow_released :: proc() {
	game.battleData.moveArrowDraw = false
}