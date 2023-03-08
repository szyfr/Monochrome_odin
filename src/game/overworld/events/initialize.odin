package events


//= Imports
import "../../../game"


//= Procedures
init :: proc() {
	game.eventmanager = new(game.EventManager)

	//chn : game.Event
	//game.battleWinEvent.chain

	game.eventmanager.eventVariables["variable_1"] = false
	game.eventmanager.eventVariables["rival_battle_1"] = false

	game.eventmanager.playerName = "TEST"
	game.eventmanager.playerPronouns[0] = "they"
	game.eventmanager.playerPronouns[1] = "them"
	game.eventmanager.playerPronouns[2] = "theirs"
	game.eventmanager.rivalName = "Silver"
}

battle_win_event :: proc() {
	//game.eventmanager.currentEvent = game.battleWinEvent
}