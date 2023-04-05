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
	
	game.eventmanager.eventVariables["chose_starter_grass"] = false
	game.eventmanager.eventVariables["chose_starter_fire"] = false
	game.eventmanager.eventVariables["chose_starter_water"] = false
	
	game.eventmanager.eventVariables["rival_starter_grass"] = false
	game.eventmanager.eventVariables["rival_starter_fire"] = false
	game.eventmanager.eventVariables["rival_starter_water"] = false


	game.eventmanager.playerName = "Gold"
	game.eventmanager.playerPronouns[0] = "they"
	game.eventmanager.playerPronouns[1] = "them"
	game.eventmanager.playerPronouns[2] = "theirs"
	game.eventmanager.rivalName = "Silver"
}