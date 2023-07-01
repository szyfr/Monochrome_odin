package battle


//= Imports
import "core:math"

import "vendor:raylib"

import "../../game"


//= Procedures
calc_turn_order :: proc() {
	playerSpd := game.battleData.playerTeam[game.battleData.currentPlayer].spd
	enemySpd  := game.battleData.enemyTeam[game.battleData.currentEnemy].spd
	switch {
		case playerSpd < enemySpd:
			game.battleData.playerFirst = false
		case playerSpd > enemySpd:
			game.battleData.playerFirst = true
	}
}

calculate_path :: proc() {
	player_pos : raylib.Vector2 = {game.battleData.field["player"].entity.position.x - 8, game.battleData.field["player"].entity.position.z - 55.75}
	current_target : raylib.Vector2 = game.battleData.target
	current_pos : raylib.Vector2 = player_pos

	distance : [4]f32

	for current_pos != current_target {
		//* Check each cardinal direction
		newDist : f32
		if spot_empty(current_pos + { 1, 0}) do distance[0] = dist(current_pos + { 1, 0}, current_target)
		else do distance[0] = 1000000
		if spot_empty(current_pos + { 0, 1}) do distance[1] = dist(current_pos + { 0, 1}, current_target)
		else do distance[1] = 1000000
		if spot_empty(current_pos + {-1, 0}) do distance[2] = dist(current_pos + {-1, 0}, current_target)
		else do distance[2] = 1000000
		if spot_empty(current_pos + { 0,-1}) do distance[3] = dist(current_pos + { 0,-1}, current_target)
		else do distance[3] = 1000000
		//distance[1] = dist(current_pos + { 0, 1}, current_target)
		//distance[2] = dist(current_pos + {-1, 0}, current_target)
		//distance[3] = dist(current_pos + { 0,-1}, current_target)

		//* Check for objects
		for i:=0;i<4;i+=1 {
			
		}

		//* Find smallest distance
		switch smallest(distance) {
			case 0: current_pos += { 1, 0}
			case 1: current_pos += { 0, 1}
			case 2: current_pos += {-1, 0}
			case 3: current_pos += { 0,-1}
		}
		append(&game.battleData.moveArrowList, current_pos)
	}
	
}

dist :: proc( p1, p2 : raylib.Vector2 ) -> f32 {
	return math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2))
}

smallest :: proc( numbers : [4]f32 ) -> int {
	smallest : int = 0
	for i:=0;i<4;i+=1 {
		if numbers[i] < numbers[smallest] do smallest = i
	}
	return smallest
}