package events


//= Imports
import "core:fmt"

import "../../../game"


//= Procedures
init :: proc() {
	game.eventmanager = new(game.EventManager)

	append(&game.battleTrainerWinEvent.chain,
		game.PlayMusicEvent{"trainer_battle_win",1},
		game.TextEvent{&game.localization["trainer_battle_win_1"]},
		game.TextEvent{&game.localization["trainer_battle_win_2"]},
		game.GiveExperience{0,0},
		game.ShowLevelUp{},
		//TODO Gib mons
		game.EndBattleEvent{},
	)
	append(&game.battleWildWinEvent.chain,
		game.PlayMusicEvent{"wild_battle_win",1},
		game.TextEvent{&game.localization["wild_battle_win_1"]},
		game.TextEvent{&game.localization["wild_battle_win_2"]},
		game.GiveExperience{0,0},
		game.ShowLevelUp{},
		game.EndBattleEvent{},
	)

	game.eventmanager.eventVariables["variable_1"] = false
	game.eventmanager.eventVariables["rival_battle_1"] = false

	game.eventmanager.playerName = "TEST"
	game.eventmanager.playerPronouns[0] = "they"
	game.eventmanager.playerPronouns[1] = "them"
	game.eventmanager.playerPronouns[2] = "theirs"
	game.eventmanager.rivalName = "Silver"
}

battle_win_event :: proc(
	trainer : bool,
) {
	if trainer	do game.eventmanager.currentEvent = &game.battleTrainerWinEvent
	else		do game.eventmanager.currentEvent = &game.battleWildWinEvent
}