package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/entity"
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

		#partial switch in curChain {
			case game.TextEvent:
				if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
					str := strings.clone_from_cstring(curChain.(game.TextEvent).text^)
					textbox.open_textbox(str)
				}
				if game.eventmanager.textbox.state == .finished {
					game.eventmanager.currentChain += 1
					if !(game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain)) {
						v, ok := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.TextEvent)
						if ok {
							textbox.reset_textbox()
						} else {
							textbox.close_textbox()
						}
					} else {
						textbox.close_textbox()
					}
				}

			case game.WarpEvent:
				warpingEnt : ^game.Entity
				for ent in game.region.entities do if game.region.entities[ent].id == curChain.(game.WarpEvent).entityid do warpingEnt = &game.region.entities[ent]
				if curChain.(game.WarpEvent).entityid == "player" do warpingEnt = game.player.entity
				if warpingEnt != nil {
					entity.teleport(game.player.entity, curChain.(game.WarpEvent).position)
					if curChain.(game.WarpEvent).move do entity.move(game.player.entity, game.player.entity.direction)
				}

				game.eventmanager.currentChain += 1

			case game.TurnEvent:
				turningEnt : ^game.Entity
				for ent in game.region.entities do if game.region.entities[ent].id == curChain.(game.TurnEvent).entityid do turningEnt = &game.region.entities[ent]
				if curChain.(game.TurnEvent).entityid == "player" do turningEnt = game.player.entity
				if turningEnt != nil {
					if turningEnt.direction == curChain.(game.TurnEvent).direction {
						game.eventmanager.currentChain += 1
					}
					entity.turn(turningEnt, curChain.(game.TurnEvent).direction)
				}

			case game.MoveEvent:
				movingEnt : ^game.Entity
				for ent in game.region.entities do if game.region.entities[ent].id == curChain.(game.MoveEvent).entityid do movingEnt = &game.region.entities[ent]
				if curChain.(game.MoveEvent).entityid == "player" do movingEnt = game.player.entity
				if movingEnt != nil {
					if !movingEnt.isMoving && curChain.(game.MoveEvent).times > game.eventmanager.uses {
						entity.move(movingEnt, curChain.(game.MoveEvent).direction)
						game.eventmanager.uses += 1
					}
					if (!movingEnt.isMoving || !curChain.(game.MoveEvent).simul ) && curChain.(game.MoveEvent).times <= game.eventmanager.uses {
						game.eventmanager.currentChain += 1
						game.eventmanager.uses = 0
					}
				}
			
			case game.WaitEvent:
				if game.eventmanager.uses < curChain.(game.WaitEvent).time {
					game.eventmanager.uses += 1
				} else {
					game.eventmanager.currentChain += 1
				}
		}
	}
}

