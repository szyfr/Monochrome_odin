package battle


//= Imports
import "core:fmt"
import "core:reflect"

import "../../game"
import "../camera"
import "../entity/overworld"
import "../monsters"
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

	game.battleData.field["player"] = game.Token{
		overworld.create(
			{3 + 8, 0, 3 + 55.75},
			reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species),
			"monster",
		)^,
		.player,
		0,
	}
	game.battleData.field["enemy"] = game.Token{
		overworld.create(
			//{12 + 8, 0, 3 + 55.75},
			{8 + 8, 0, 3 + 55.75},
			reflect.enum_string(game.battleData.enemyTeam[game.battleData.currentEnemy].species),
			"monster",
		)^,
		.enemy,
		0,
	}

	calc_turn_order()
	if game.battleData.playerFirst {
		monsters.start_turn(&game.battleData.playerTeam[game.battleData.currentPlayer])
		game.battleData.playersTurn = true
	} else do monsters.start_turn(&game.battleData.enemyTeam[game.battleData.currentEnemy])

	game.battleData.experience = 0

	camera.defocus()
	game.camera.zoom = 1.2
	camera.set_position( {16,0,60} )

	game.battleData.event = nil

	return true
}

close :: proc() {
	free(game.battleData)
	game.battleData = nil

	camera.focus(game.player.entity)
	game.camera.zoom = 1
}