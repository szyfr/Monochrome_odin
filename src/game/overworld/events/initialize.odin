package events


//= Imports
import "core:fmt"

import "../../../game"


//= Procedures
init :: proc() {
	game.eventmanager = new(game.EventManager)

	create_battle_defaults()

	game.eventmanager.eventVariables["variable_1"] = false
	game.eventmanager.eventVariables["rival_battle_1"] = false
	game.eventmanager.eventVariables["talked_mom_1"] = false

	game.eventmanager.eventVariables["tut_elm_series"] = 0
	game.eventmanager.eventVariables["talked_elm_1"] = false
	game.eventmanager.eventVariables["talked_elm_2"] = false
	game.eventmanager.eventVariables["talked_elm_3"] = false
	
	game.eventmanager.eventVariables["chose_chikorita"] = false
	game.eventmanager.eventVariables["chose_cyndaquil"] = false
	game.eventmanager.eventVariables["chose_totodile"] = false
	
	game.eventmanager.eventVariables["rival_chikorita"] = false
	game.eventmanager.eventVariables["rival_cyndaquil"] = false
	game.eventmanager.eventVariables["rival_totodile"] = false


	game.eventmanager.playerName = "Gold"
	game.eventmanager.playerPronouns[0] = "they"
	game.eventmanager.playerPronouns[1] = "them"
	game.eventmanager.playerPronouns[2] = "theirs"
	game.eventmanager.rivalName = "Silver"
}