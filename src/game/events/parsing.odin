package events


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../graphics/ui"
import "../entity/overworld"
import "../entity/emotes"
import "../audio"


//= Procedures
parse_events :: proc() {
	chain		:= &game.eventmanager.currentEvent.chain
	curLink		:=  game.eventmanager.currentChain
	curChain	:= &game.eventmanager.currentEvent.chain[curLink]

	#partial switch in curChain {
		case game.TextEvent: event_text(&curChain.(game.TextEvent))
		case game.ChoiceEvent: event_text_choice(&curChain.(game.ChoiceEvent))
		case game.ShowLevelUp: event_show_levelup(&curChain.(game.ShowLevelUp))

		case game.WarpEvent: event_warp(&curChain.(game.WarpEvent))
		case game.TurnEvent: event_turn(&curChain.(game.TurnEvent))
		case game.MoveEvent: event_move(&curChain.(game.MoveEvent))

		case game.WaitEvent: event_wait(&curChain.(game.WaitEvent))

		case game.ConditionalEvent: event_conditional(&curChain.(game.ConditionalEvent))
		case game.SetConditionalEvent: event_set_conditional(&curChain.(game.SetConditionalEvent))

		case game.SetTileEvent: event_set_tile(&curChain.(game.SetTileEvent))

		case game.GetMonsterEvent: event_receive_monster(&curChain.(game.GetMonsterEvent))
		
		case game.StartBattleEvent: event_start_battle(&curChain.(game.StartBattleEvent))
		case game.EndBattleEvent: event_end_battle(&curChain.(game.EndBattleEvent))

		case game.PlaySoundEvent: event_play_sound(&curChain.(game.PlaySoundEvent))
		case game.PlayMusicEvent: event_play_music(&curChain.(game.PlayMusicEvent))

		case game.EmoteEvent: event_emote(&curChain.(game.EmoteEvent))

		case game.OverlayAnimationEvent: event_animation_overlay(&curChain.(game.OverlayAnimationEvent))
			
		case game.GiveExperience: event_gain_exp(&curChain.(game.GiveExperience))

		case game.SkipEvent: event_skip(&curChain.(game.SkipEvent))
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

// TODO
event_text_choice :: proc( curChain : ^game.ChoiceEvent ) {
	if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
		str := strings.clone_from_cstring(curChain.text^)
		ui.open_textbox(str, true, curChain.choices)
	}
	if game.eventmanager.textbox.state == .finished {
		game.eventmanager.currentChain += 1
		evt := curChain.choices[game.eventmanager.textbox.curPosition].event
		#partial switch in evt {
			case (string):
				evnt, res := game.region.events[evt.(string)]
				if !res {
					game.eventmanager.currentChain += 1
					return
				}
				game.eventmanager.currentChain = 0
				game.eventmanager.currentEvent = &game.region.events[evt.(string)]
			case (int):
				game.eventmanager.currentChain = evt.(int)
		}
		game.eventmanager.textbox.curPosition = 0

		newChain := game.eventmanager.currentEvent.chain[game.eventmanager.currentChain]
		_, ok1 := newChain.(game.TextEvent)
		_, ok2 := newChain.(game.ChoiceEvent)
		_, ok3 := newChain.(game.ShowLevelUp)
		
		//* Reset if next event is also text-based, else close
		if ok1 || ok2 || ok3 do ui.reset_textbox()
		else do ui.close_textbox()
	}
}

// TODO
event_show_levelup :: proc( curChain : ^game.ShowLevelUp ) {
//	//* Check if textbox is inactive or reset, open it if so.
//	if game.eventmanager.textbox.state == .inactive || game.eventmanager.textbox.state == .reset {
//		str := strings.clone_from_cstring(game.localization["level_up"])
//		ui.open_textbox(str)
//		game.levelUpDisplay = curChain
//	}
//	//* Check if textbox is finished
//	if game.eventmanager.textbox.state == .finished {
		game.eventmanager.currentChain += 1
//		if !(game.eventmanager.currentChain >= len(game.eventmanager.currentEvent.chain)) {
//			newChain := &game.eventmanager.currentEvent.chain[game.eventmanager.currentChain]
//			_, ok1 := newChain.(game.TextEvent)
//			_, ok2 := newChain.(game.ChoiceEvent)
//			_, ok3 := newChain.(game.ShowLevelUp)
//			if ok1 || ok2 || ok3 {
//				game.levelUpDisplay = nil
//				ui.reset_textbox()
//			} else {
//				game.levelUpDisplay = nil
//				ui.close_textbox()
//			}
//		} else {
//			game.levelUpDisplay = nil
//			ui.close_textbox()
//		}
//	}
}


event_warp :: proc( curChain : ^game.WarpEvent ) {
	warpingEnt : ^game.Entity = overworld.get_entity(curChain.entityid)

	if warpingEnt != nil {
		overworld.teleport(warpingEnt, curChain.position)
		if curChain.move do overworld.move(warpingEnt, curChain.direction)
	}

	game.eventmanager.currentChain += 1
}

event_turn :: proc( curChain : ^game.TurnEvent ) {
	turningEnt : ^game.Entity = overworld.get_entity(curChain.entityid)
	
	if turningEnt != nil {
		overworld.turn(turningEnt, curChain.direction)
	}

	game.eventmanager.currentChain += 1
}

event_move :: proc( curChain : ^game.MoveEvent ) {
	movingEnt : ^game.Entity = overworld.get_entity(curChain.entityid)

	if movingEnt != nil {
		if !movingEnt.isMoving && curChain.times > game.eventmanager.uses {
			overworld.move(movingEnt, curChain.direction)
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

// TODO
event_conditional :: proc( curChain : ^game.ConditionalEvent ) {
//	if game.check_variable(curChain^) {
//		switch curChain.eventType {
//			case .new_event:
//				evt, rs := game.region.events[curChain.eventData.(raylib.Vector2)]
//				if !rs {
//					game.eventmanager.currentChain += 1
//					return
//				}
//				game.eventmanager.currentChain = 0
//				game.eventmanager.uses = 0
//				game.eventmanager.currentEvent = &evt
//			case .jump_chain:
//				game.eventmanager.currentChain += curChain.eventData.(int)
//			case .set_chain:
//				game.eventmanager.currentChain = curChain.eventData.(int)
//			case .leave_chain:
//				game.eventmanager.currentChain = 10000
//			case .start_battle:
//				battle.init(&game.battles[curChain.eventData.(string)])
				game.eventmanager.currentChain += 1
//		}
//	} else {
//		game.eventmanager.currentChain += 1
//	}
}

event_set_conditional :: proc( curChain : ^game.SetConditionalEvent ) {
	game.eventmanager.eventVariables[curChain.variableName] = curChain.value
	game.eventmanager.currentChain += 1
}

event_set_tile :: proc( curChain : ^game.SetTileEvent ) {
	tile := &game.region.tiles[curChain.position]
	tile.model = curChain.value
	tile.solid = curChain.solid
	tile.surf  = curChain.surf
	game.eventmanager.currentChain += 1
}

// TODO
event_receive_monster :: proc( curChain : ^game.GetMonsterEvent ) {
//	monsters.add_to_team(monsters.create(
//		curChain.species,
//		curChain.level,
//	))
//	game.eventmanager.currentChain += 1
}

// TODO
event_start_battle :: proc( curChain : ^game.StartBattleEvent ) {
//	if game.player.monster[0].species == .empty do return
//
//	battle.init(&game.battles[curChain.id])
//	game.eventmanager.currentChain += 1
}

// TODO
event_end_battle :: proc( curChain : ^game.EndBattleEvent ) {
//	battle.close()
//	game.eventmanager.currentChain += 1
}

event_play_sound :: proc( curChain : ^game.PlaySoundEvent ) {
	audio.play_sound(curChain.name, curChain.pitch)
	game.eventmanager.currentChain += 1
}

event_play_music :: proc( curChain : ^game.PlayMusicEvent ) {
	audio.play_music(curChain.name, curChain.pitch)
	game.eventmanager.currentChain += 1
}

event_animation_overlay :: proc( curChain : ^game.OverlayAnimationEvent ) {
	//* Initial
	if game.eventmanager.uses == 0 {
		game.overlayTexture = curChain.texture
		game.overlayActive	= true
	}

	//* Ending
	if game.eventmanager.uses >= curChain.length {
		game.eventmanager.uses = 0
		game.eventmanager.currentChain += 1

		if !curChain.stay {
			game.overlayTexture = {}
			game.overlayActive = false
			game.overlayRectangle = {}
		}
	} else {
		//* Ongoing
		game.eventmanager.uses += 1
		mod := game.eventmanager.uses / curChain.timer
		game.overlayRectangle = {
			f32(curChain.animation[mod % (len(curChain.animation))] * 256),
			0,
			255,
			144,
		}

	}
}

event_skip :: proc( curChain : ^game.SkipEvent ) {
	//TODO Rework to allow different types of skips
	game.eventmanager.currentChain = curChain.event
}

// TODO
event_gain_exp :: proc( curChain : ^game.GiveExperience ) {
//	if game.eventmanager.uses >= curChain.amount * 3 {
//		game.eventmanager.currentChain += 1
//		return
//	}
//	if game.eventmanager.uses % 3 == 0 && game.eventmanager.uses > 0 {
//		//audio.play_sound("experience") //TODO experience gain noise
//		result := monsters.give_experience(&game.player.monster[curChain.member], 1)
//		if result {
//			curChain.amount -= game.eventmanager.uses / 3
//			game.eventmanager.uses = -170
//		}
//	}
//	game.eventmanager.uses += 1
}

event_emote :: proc( curChain : ^game.EmoteEvent ) {
	time := int(curChain.multiplier * 50)
	if game.eventmanager.uses == 0 {
		emotingEnt := overworld.get_entity(curChain.entityid)
		if emotingEnt == nil {
			game.eventmanager.currentChain += 1
			return
		}
		emotes.create(
			emotingEnt.position,
			time,
			curChain.emote,
		)
		game.eventmanager.uses += 1
	} else if game.eventmanager.uses < time {
		game.eventmanager.uses += 1
	} else {
		game.eventmanager.currentChain += 1
		game.eventmanager.uses = 0
	}
	if !curChain.skipwait {
		game.eventmanager.currentChain += 1
		game.eventmanager.uses = 0
	}
}