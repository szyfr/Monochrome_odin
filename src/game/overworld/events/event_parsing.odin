package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../game"
import "../entity"
import "../../battle"
import "../../battle/monsters"
import "../../general/graphics/ui"
import "../../general/audio"


//= Procedures
parse_events :: proc() {
	chain		:= &game.eventmanager.currentEvent.chain
	curLink		:=  game.eventmanager.currentChain
	curChain	:= &game.eventmanager.currentEvent.chain[game.eventmanager.currentChain]

	#partial switch in curChain {
		case game.TextEvent: event_text(&curChain.(game.TextEvent))
		case game.WarpEvent: event_warp(&curChain.(game.WarpEvent))
		case game.TurnEvent: event_turn(&curChain.(game.TurnEvent))
		case game.MoveEvent: event_move(&curChain.(game.MoveEvent))
		case game.WaitEvent: event_wait(&curChain.(game.WaitEvent))
			
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
						charPos		= {
							emotingEnt.position.x,
							emotingEnt.position.z,
						},
						duration	= int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier),
						maxDuration	= int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier),
					}
					if curChain.(game.EmoteEvent).entityid == "player" do strc.player = true
					append(&game.emoteList, strc)
					//TODO Noise

					if !curChain.(game.EmoteEvent).skipwait do game.eventmanager.currentChain += 1
					
					game.eventmanager.uses += 1
				} else if game.eventmanager.uses < int(f32(EMOTE_DURATION) * curChain.(game.EmoteEvent).multiplier) && emotingEnt != nil {
					game.eventmanager.uses += 1
				} else {
					game.eventmanager.uses = 0
					game.eventmanager.currentChain += 1
				}
			
		case game.ConditionalEvent:
				if game.check_variable(curChain.(game.ConditionalEvent)) {
					evt := curChain.(game.ConditionalEvent).event
					#partial switch in evt {
						case (raylib.Vector2):
							evnt, res := game.region.events[curChain.(game.ChoiceEvent).choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
							if !res {
								game.eventmanager.currentChain += 1
								return
							}
							game.eventmanager.currentChain = 0
							game.eventmanager.currentEvent = &game.region.events[curChain.(game.ChoiceEvent).choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
						case (int):
							game.eventmanager.currentChain = evt.(int)
						case (string):
							battle.init(&game.battles[evt.(string)])
							game.eventmanager.currentChain += 1

					}
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
			
		case game.StartBattleEvent:
				//TODO Run check for if the player doesn't have a pokemon
				battle.init(&game.battles[curChain.(game.StartBattleEvent).id])
				game.eventmanager.currentChain += 1
			
		case game.EndBattleEvent:
				battle.close()
				game.eventmanager.currentChain += 1

		case game.PlaySoundEvent:
				audio.play_sound(curChain.(game.PlaySoundEvent).name, curChain.(game.PlaySoundEvent).pitch)
				game.eventmanager.currentChain += 1

		case game.PlayMusicEvent:
				audio.play_music(curChain.(game.PlayMusicEvent).name, curChain.(game.PlayMusicEvent).pitch)
				game.eventmanager.currentChain += 1

		case game.OverlayAnimationEvent:
				if game.eventmanager.uses == 0 {
					game.overlayTexture = curChain.(game.OverlayAnimationEvent).texture
					game.overlayActive	= true
				}
				if game.eventmanager.uses >= curChain.(game.OverlayAnimationEvent).length {
					game.eventmanager.uses = 0
					game.eventmanager.currentChain += 1

					if !curChain.(game.OverlayAnimationEvent).stay {
						game.overlayTexture = {}
						game.overlayActive = false
						game.overlayRectangle = {}
					}
				} else {
					game.eventmanager.uses += 1
					mod := game.eventmanager.uses / curChain.(game.OverlayAnimationEvent).timer
					game.overlayRectangle = {
						f32(curChain.(game.OverlayAnimationEvent).animation[mod % (len(curChain.(game.OverlayAnimationEvent).animation))] * 256),
						0,
						255,
						144,
					}

				}

		case game.ChoiceEvent:
				if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
					str := strings.clone_from_cstring(curChain.(game.ChoiceEvent).text^)
					ui.open_textbox(str, true, curChain.(game.ChoiceEvent).choices)
				}
				if game.eventmanager.textbox.state == .finished {
					game.eventmanager.currentChain += 1
					evt := curChain.(game.ChoiceEvent).choices[game.eventmanager.textbox.curPosition].event
					#partial switch in evt {
						case (raylib.Vector2):
							evnt, res := game.region.events[curChain.(game.ChoiceEvent).choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
							if !res {
								game.eventmanager.currentChain += 1
								return
							}
							game.eventmanager.currentChain = 0
							game.eventmanager.currentEvent = &game.region.events[curChain.(game.ChoiceEvent).choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
						case (int):
							game.eventmanager.currentChain = evt.(int)
					}

					game.eventmanager.textbox.curPosition = 0
					
					_, ok1 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.TextEvent)
					_, ok2 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.ChoiceEvent)
					_, ok3 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.ShowLevelUp)
					if ok1 || ok2 || ok3 {
						ui.reset_textbox()
					} else {
						ui.close_textbox()
					}
				}
			
		case game.GiveExperience:
				if game.eventmanager.uses >= curChain.(game.GiveExperience).amount * 3 {
					game.eventmanager.currentChain += 1
					break
				}
				if game.eventmanager.uses % 3 == 0 && game.eventmanager.uses > 0 {
					//audio.play_sound("experience") //TODO experience gain noise
					result := monsters.give_experience(&game.player.pokemon[curChain.(game.GiveExperience).member], 1)
					if result {
						chn := &curChain.(game.GiveExperience)
						chn.amount -= game.eventmanager.uses / 3
						game.eventmanager.uses = -170
					}
				}
				game.eventmanager.uses += 1

		case game.ShowLevelUp:
				if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
					str := strings.clone_from_cstring(game.localization["level_up"])
					ui.open_textbox(str)
					game.levelUpDisplay = &curChain.(game.ShowLevelUp)
				}
				if game.eventmanager.textbox.state == .finished {
					game.eventmanager.currentChain += 1
					if !(game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain)) {
						_, ok1 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.TextEvent)
						_, ok2 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.ChoiceEvent)
						_, ok3 := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.ShowLevelUp)
						if ok1 || ok2 || ok3 {
							game.levelUpDisplay = nil
							ui.reset_textbox()
						} else {
							game.levelUpDisplay = nil
							ui.close_textbox()
						}
					} else {
						game.levelUpDisplay = nil
						ui.close_textbox()
					}
				}

		case game.SkipEvent:
				game.eventmanager.currentChain = game.eventmanager.currentEvent.chain[game.eventmanager.currentChain].(game.SkipEvent).event
	}
}

event_text :: proc( curChain : ^game.TextEvent ) {
	//* Check if textbox is inactive or reset, open it if so.
	if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
		str := strings.clone_from_cstring(curChain.text^)
		ui.open_textbox(str)
	}
	//* Check if textbox is finished
	if game.eventmanager.textbox.state == .finished {
		game.eventmanager.currentChain += 1
		if !(game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain)) {
			newChain := &game.eventmanager.currentEvent.chain[game.eventmanager.currentChain]
			_, ok1 := newChain.(game.TextEvent)
			_, ok2 := newChain.(game.ChoiceEvent)
			_, ok3 := newChain.(game.ShowLevelUp)

			//* Reset if next event is also text-based, else close
			if ok1 || ok2 || ok3 do ui.reset_textbox()
			else do ui.close_textbox()
		} else do ui.close_textbox()
	}
}

event_warp :: proc( curChain : ^game.WarpEvent ) {
	warpingEnt : ^game.Entity = entity.get_entity(curChain.entityid)

	if warpingEnt != nil {
		entity.teleport(warpingEnt, curChain.position)
		if curChain.move do entity.move(warpingEnt, curChain.direction)
	}

	game.eventmanager.currentChain += 1
}

event_turn :: proc( curChain : ^game.TurnEvent ) {
	turningEnt : ^game.Entity = entity.get_entity(curChain.entityid)
	
	if turningEnt != nil {
		entity.turn(turningEnt, curChain.direction)
	}

	game.eventmanager.currentChain += 1
}

event_move :: proc( curChain : ^game.MoveEvent ) {
	movingEnt : ^game.Entity = entity.get_entity(curChain.entityid)

	if movingEnt != nil {
		if !movingEnt.isMoving && curChain.times > game.eventmanager.uses {
			entity.move(movingEnt, curChain.direction)
			game.eventmanager.uses += 1
		}
		if (!movingEnt.isMoving || !curChain.simul ) && curChain.times <= game.eventmanager.uses {
			game.eventmanager.currentChain += 1
			game.eventmanager.uses = 0
		}
	}
}

event_wait :: proc( curChain : ^game.WaitEvent ) {
	if game.eventmanager.uses < curChain.time {
		game.eventmanager.uses += 1
	} else {
		game.eventmanager.currentChain += 1
		game.eventmanager.uses = 0
	}
}

event_conditional :: proc( curChain : ^game.ConditionalEvent ) {
	if game.check_variable(curChain^) {
		evt := curChain.event
		#partial switch in evt {
			case (raylib.Vector2):
				//evnt, res := game.region.events[curChain.choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
				//if !res {
				//	game.eventmanager.currentChain += 1
				//	return
				//}
				//game.eventmanager.currentChain = 0
				//game.eventmanager.currentEvent = &game.region.events[curChain.choices[game.eventmanager.textbox.curPosition].event.(raylib.Vector2)]
			case (int):
				game.eventmanager.currentChain = evt.(int)
			case (string):
				battle.init(&game.battles[evt.(string)])
				game.eventmanager.currentChain += 1

		}
	} else {
		game.eventmanager.currentChain += 1
	}
}