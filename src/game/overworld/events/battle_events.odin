package events


//= Imports
import "core:fmt"

import "../../../game"


//= Procedures
create_battle_defaults :: proc() {
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
	append(&game.battleTrainerLoseEvent.chain,
		game.PlayMusicEvent{"",1},
		game.TextEvent{&game.localization["trainer_battle_lose_1"]},
		game.TextEvent{&game.localization["trainer_battle_lose_2"]},
		//TODO Lose mons
		game.WarpEvent{"player",{32,0,41},.up,false},
		game.EndBattleEvent{},
	)
}

battle_win_event :: proc(
	trainer : bool,
) {
	if trainer	do game.eventmanager.currentEvent = &game.battleTrainerWinEvent
	else		do game.eventmanager.currentEvent = &game.battleWildWinEvent
}