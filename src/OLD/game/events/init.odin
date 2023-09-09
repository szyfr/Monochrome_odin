package events


//= Imports
import "../../game"


//= Procedures
init :: proc() {
	game.eventmanager = new(game.EventManager)

	//create_battle_defaults()

	// TODO: TEMP
	game.eventmanager.playerName = "Gold"
	game.eventmanager.playerPronouns[0] = "they"
	game.eventmanager.playerPronouns[1] = "them"
	game.eventmanager.playerPronouns[2] = "theirs"
	game.eventmanager.rivalName = "Silver"
}

reset :: proc() {
	game.eventmanager.currentEvent	= nil
	game.eventmanager.textbox		= {}
	game.eventmanager.currentChain	= 0
	game.eventmanager.uses			= 0
}