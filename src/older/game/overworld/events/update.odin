package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../game"
import "../entity"
import "../../battle/monsters"
import "../../battle"
import "../../general/graphics/ui"
import "../../general/audio"


//= Constants
EMOTE_DURATION :: 50


//= Procedures
update :: proc() {
	if game.eventmanager.currentEvent != nil {
		if game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain) {
			game.eventmanager.currentEvent = nil
			game.eventmanager.currentChain = 0
			game.eventmanager.uses = 0
			game.player.canMove = true
			return
		}

		parse_events()
	}
}

