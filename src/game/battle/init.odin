package battle


//= Imports
import "core:reflect"

import "../../game"
import "../camera"
import "../entity/overworld"
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

	append(&game.battleData.field, game.Token{
		overworld.create(
			{5 + 8, 0, 3 + 55.75},
			reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species),
			"monster",
		)^,
		.player,
		0,
	})
	append(&game.battleData.field, game.Token{
		overworld.create(
			{10 + 8, 0, 3 + 55.75},
			reflect.enum_string(game.battleData.enemyTeam[game.battleData.currentEnemy].species),
			"monster",
		)^,
		.enemy,
		0,
	})
	

	//append(&game.battleData.entities, overworld.create(
	//	{5 + 8, 0, 3 + 55.75},
	//	reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species),
	//	"monster",
	//)^)
	//append(&game.battleData.entities, overworld.create(
	//	{5 + 8, 0, 10 + 55.75},
	//	reflect.enum_string(game.battleData.enemyTeam[game.battleData.currentEnemy].species),
	//	"monster",
	//)^)

	calc_turn_order()
	if game.battleData.playerFirst do game.battleData.playersTurn = true

	camera.defocus()
	game.camera.zoom = 1.2
	camera.set_position( {16,0,60} )

	return true
}

close :: proc() {
	free(game.battleData)
	game.battleData = nil

	camera.focus(game.player.entity)
	game.camera.zoom = 1
}