package battle


//= Imports
import "core:fmt"
import "core:math"
import "core:math/rand"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"


//= Procedures
calc_direction :: proc( p1,p2 : raylib.Vector3 ) -> game.Direction {
	distance := dist(p1, p2)
	direction : game.Direction

	if distance > dist(p1 + { 1, 0, 0}, p2) do direction = .right
	if distance > dist(p1 + {-1, 0, 0}, p2) do direction = .left
	if distance > dist(p1 + { 0, 0, 1}, p2) do direction = .down
	if distance > dist(p1 + { 0, 0,-1}, p2) do direction = .up

	return direction
}
process_turn :: proc() {
	enemy			:= &game.battleData.enemyTeam[game.battleData.currentEnemy]
	enemyBrain		:= &enemy.ai
	enemyToken		:= &game.battleData.field["enemy"]
	enemyEntity		:= &enemyToken.entity
	enemyPosition	:=  game.battleData.field["enemy"].entity.position
	player			:= &game.battleData.playerTeam[game.battleData.currentPlayer]
	playerPosition	:=  game.battleData.field["player"].entity.position

	distance := dist(enemyPosition, playerPosition)
	overworld.turn(enemyEntity, calc_direction(enemyPosition, playerPosition), true)


	//= Calculate what attack to use
	//* Roll for aggression. Value between the monster's base aggression value and 10
	aggressionRoll : int
	for {
		aggressionRoll = rand.int_max(11)
		if aggressionRoll >= enemyBrain.aggression do break
	}

	//* Decide which attacks it can use based on the aggression roll
	usageOptions : [dynamic]int
	for i in 0..<4 {
		if enemyBrain.attack[i].aggression >= aggressionRoll do append(&usageOptions, i)
	}

	//* Calculate weights for attacks
	weights : [dynamic]int
	for i:=0;i<len(usageOptions);i+=1 {
		append(&weights, 0)

		//* Weight positively if super effective if damaging
		if enemyBrain.attack[usageOptions[i]].damaging {
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 0.00 do weights[i] -= 10
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 0.33 do weights[i] -=  2
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 0.66 do weights[i] -=  1
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 1.00 do weights[i] +=  0
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 1.50 do weights[i] +=  1
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 2.00 do weights[i] +=  2
			if type_damage_multiplier(enemyBrain.attack[usageOptions[i]].type, player, false) == 2.50 do weights[i] +=  5
		}

		//* Weight positively if category matches with monsters style
		if enemyBrain.attack[usageOptions[i]].category == .physical && enemyBrain.special == 0 do weights[i] += 1
		if enemyBrain.attack[usageOptions[i]].category == .special  && enemyBrain.special == 1 do weights[i] += 1
		if (enemyBrain.attack[usageOptions[i]].category == .physical || enemyBrain.attack[usageOptions[i]].category == .special) && enemyBrain.special == 2 do weights[i] += 1

		//* Weight status moves if aggression is less than or equal to 5
		if aggressionRoll <= 5 && enemyBrain.attack[usageOptions[i]].category == .other do weights[i] += 2

		//* Weight moves lower if they can't reach
		if int(distance) > enemyBrain.attack[usageOptions[i]].range + enemy.movesCur do weights[i] -= 10
	}

	//* Check which attack is weighted higher
	decision, weight : int = -1, -100
	for i:=0;i<len(usageOptions);i+=1 {
		if weights[i] > weight {
			decision = usageOptions[i]
			weight = weights[i]
		}
	}
	if weight < 0 do decision = -1
	
	//* Move Closer
	distanceKeep : int
	switch enemyBrain.type {
		case .tank_setup:		distanceKeep = 3
		case .ranged_special:	distanceKeep = 4
		case .brawler_physical:	distanceKeep = 1
	}

	for {
		lined := (enemyPosition.x == playerPosition.x || enemyPosition.z == playerPosition.z)
		if enemy.movesCur == 0 || (lined && int(distance) <= distanceKeep) do break

		//overworld.move(enemyEntity, enemyEntity.direction)
		switch enemyEntity.direction {
			case .right:	enemyEntity.position += {1,0,0}
			case .left:		enemyEntity.position -= {1,0,0}
			case .down:		enemyEntity.position -= {0,0,1}
			case .up:		enemyEntity.position += {0,0,1}
		}
		enemy.movesCur -= 1
	}

	//* If attack chosen, use it
	for {
		if decision == -1 do break
		if enemy.stCur < enemyBrain.attack[decision].stCost do break
		fmt.printf("%v: %v-%v\n",enemyBrain.attack[decision].attack, enemy.stCur, enemyBrain.attack[decision].stCost)

		overworld.turn(enemyEntity, calc_direction(enemyPosition, playerPosition), true)

		use_attack(false, decision)
	}

}
