package battle


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "../../game"
import "../monsters"


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
		//* Leave if line too long
		monster := &game.battleData.playerTeam[game.battleData.currentPlayer]
		if monster.movesCur - len(game.battleData.moveArrowList) == 0 do return

		//* Add the current tile if it wasn't that las one added
		lastMember : int
		if len(game.battleData.moveArrowList) - 1 >= 0 {
			lastMember = len(game.battleData.moveArrowList) - 1
			if game.battleData.moveArrowList[lastMember] != game.battleData.target do append(&game.battleData.moveArrowList, game.battleData.target)
		} else {
			playerPos : raylib.Vector2 = {game.battleData.field["player"].entity.position.x - 8, game.battleData.field["player"].entity.position.z - 55.75}
			if game.battleData.target != playerPos do append(&game.battleData.moveArrowList, game.battleData.target)
		}
	}
}
arrow_released :: proc() {
	game.battleData.moveArrowDraw = false
}