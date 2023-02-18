package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/textbox"


//= Procedures
update :: proc() {
	if game.eventmanager.currentEvent != nil {
		if game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain) {
			game.eventmanager.currentEvent = nil
			game.eventmanager.currentChain = 0
			game.player.canMove = true
			return
		}

		chain		:= &game.eventmanager.currentEvent.chain
		curLink		:= game.eventmanager.currentChain
		curChain	:= &game.eventmanager.currentEvent.chain[game.eventmanager.currentChain]

		switch in curChain {
			case ^cstring:
				if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
					str := strings.clone_from_cstring(curChain.(^cstring)^)
					textbox.open_textbox(str)
				}
				if game.eventmanager.textbox.state == .finished {
					game.eventmanager.currentChain += 1
					if !(game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain)) {
						v, ok := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(^cstring)
						if ok {
							textbox.reset_textbox()
						} else {
							textbox.close_textbox()
						}
					} else {
						textbox.close_textbox()
					}
				}

			case raylib.Vector3:
				
		}
	}
}

