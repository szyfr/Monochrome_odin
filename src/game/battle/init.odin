package battle


//= Imports
import "../../game"
import "../camera"
import "../../debug"


//= Procedures
init :: proc( battle : string ) -> bool {
	game.battleData = new(game.BattleData)

	battleInfo, res := game.region.battles[battle]
	if !res {
		debug.log("[ERROR] - Failed to load battle.")
		return false
	}

	game.battleData.trainerName = battleInfo.trainerName
	game.battleData.arenaType = battleInfo.arenaType
	
	switch game.difficulty {
		case .easy:		game.battleData.enemyTeam = battleInfo.teamEasy
		case .medium:	game.battleData.enemyTeam = battleInfo.teamMedium
		case .hard:		game.battleData.enemyTeam = battleInfo.teamHard
	}

	game.battleData.playerTeam = &game.player.monsters

	game.battleData.squares[4][4] = &game.battleData.playerTeam[0]
	game.battleData.squares[4][11] = &game.battleData.enemyTeam[0]

	camera.defocus()
	camera.set_position( {16,0,61} )

	return true
}

close :: proc() {
	free(game.battleData)
}