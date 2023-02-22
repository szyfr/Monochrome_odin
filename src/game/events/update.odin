package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/entity"
import "../../game/textbox"
import "../../game/monsters"


//= Constants
EMOTE_DURATION :: 50


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
					game.eventmanager.uses = 0
				}
			
			case game.EmoteEvent:
				emotingEnt : ^game.Entity
				for ent in game.region.entities do if game.region.entities[ent].id == curChain.(game.EmoteEvent).entityid do emotingEnt = &game.region.entities[ent]
				if curChain.(game.EmoteEvent).entityid == "player" do emotingEnt = game.player.entity
				
				if game.eventmanager.uses == 0 && emotingEnt != nil {
					position : raylib.Vector2 = raylib.GetWorldToScreen(emotingEnt.position + {0,2.25,0}, game.camera)
					src : raylib.Rectangle = {
						16 * f32(curChain.(game.EmoteEvent).emote),
						0,
						16,16,
					}
					dest : raylib.Rectangle = {
						position.x,
						position.y,
						80,80,
					}
					strc : game.EmoteStruct = {
						src			= src,
						dest		= dest,
						duration	= int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier),
						maxDuration	= int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier),
					}
					if curChain.(game.EmoteEvent).entityid == "player" do strc.player = true
					append(&game.emoteList, strc)
					//TODO Noise
					
					game.eventmanager.uses += 1
				} else if game.eventmanager.uses < int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier) && emotingEnt != nil {
					game.eventmanager.uses += 1
				} else {
					game.eventmanager.uses = 0
					game.eventmanager.currentChain += 1
				}
			
			case game.ConditionalEvent:
				if game.check_variable(curChain.(game.ConditionalEvent)) {
					evt, res := game.region.events[curChain.(game.ConditionalEvent).event]
					if !res {
						game.eventmanager.currentChain += 1
						return
					}

					game.eventmanager.currentChain = 0
					game.eventmanager.currentEvent = &game.region.events[curChain.(game.ConditionalEvent).event]
				} else {
					game.eventmanager.currentChain += 1
				}

			case game.SetConditionalEvent:
				game.eventmanager.eventVariables[curChain.(game.SetConditionalEvent).variableName] = curChain.(game.SetConditionalEvent).value
				game.eventmanager.currentChain += 1

			case game.SetTileEvent:
				tile := &game.region.tiles[curChain.(game.SetTileEvent).position]
				tile.model = curChain.(game.SetTileEvent).value
				tile.solid = curChain.(game.SetTileEvent).solid
				tile.surf  = curChain.(game.SetTileEvent).surf
				game.eventmanager.currentChain += 1

			case game.GetPokemonEvent:
				monsters.add_to_team(monsters.create(
					curChain.(game.GetPokemonEvent).species,
					curChain.(game.GetPokemonEvent).level,
				))
				game.eventmanager.currentChain += 1
		}
	}
}

