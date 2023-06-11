package battle


//= Imports
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