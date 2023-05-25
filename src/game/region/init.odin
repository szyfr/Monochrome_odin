package region


//= Imports
import "core:encoding/json"
import "core:os"
import "core:fmt"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../entity/overworld"
import "../../debug"


//= Procedures
init :: proc(
	filename : string,	// TODO: Temp
) {
	game.region = new(game.Region)

	//* Load
	load_map(strings.concatenate({filename, "map", ".json"}))
	load_entities(strings.concatenate({filename, "entities", ".json"}))
	load_events(strings.concatenate({filename, "events", ".json"}))
	load_battles(strings.concatenate({filename, "battles", ".json"}))
	

	//* Events
	//for i:=0;i<len(eventList);i+=1 {
	//	
	//}
	//* Entities
	//
}

load_map :: proc( filename : string ) {
	rawfile, errorRaw := os.read_entire_file(filename)
	if !errorRaw {
		debug.log("[ERROR] - Failed to load tilemap file.")
		game.running = false
		return
	}
	jsonfile, errorJson := json.parse(rawfile, .JSON5)
	if errorJson != .None {
		debug.logf("[ERROR] - Failed to parse tilemap file. (%f)",errorJson)
		game.running = false
		return
	}

	game.region.size.x = f32(jsonfile.(json.Object)["width"].(f64))
	game.region.size.y = f32(jsonfile.(json.Object)["height"].(f64))

	tileList := jsonfile.(json.Object)["tiles"].(json.Array)

	//* Parsing data
	//TODO Rewrite format
	//TODO Check if it's the correct size
	for y:=0;y<int(game.region.size.y);y+=1 {
		for x:=0;x<int(game.region.size.x);x+=1 {
			count := (y*int(game.region.size.x))+x

			tile : game.Tile = {}
			tile.model	= tileList[count].(json.Object)["tile"].(string)
			tile.pos	= {
				f32(x),
				f32(tileList[count].(json.Object)["level"].(f64)),
				f32(y),
			}
			tile.solid = tileList[count].(json.Object)["solid"].(bool)
			tile.surf  = tileList[count].(json.Object)["surf"].(bool)
			game.region.tiles[{tile.pos.x,tile.pos.z}] = tile
		}
	}
}

load_entities :: proc ( filename : string ) {
	rawfile, errorRaw := os.read_entire_file(filename)
	if !errorRaw {
		debug.log("[ERROR] - Failed to load entities file.")
		game.running = false
		return
	}
	jsonfile, errorJson := json.parse(rawfile, .JSON5)
	if errorJson != .None {
		debug.log("[ERROR] - Failed to parse entities file.")
		game.running = false
		return
	}

	entityList := jsonfile.(json.Object)["entities"].(json.Array)

	for i:=0;i<len(entityList);i+=1 {
		//* Position
		locationX := f32(entityList[i].(json.Object)["location"].(json.Array)[0].(f64))
		locationZ := f32(entityList[i].(json.Object)["location"].(json.Array)[1].(f64))
		height := game.region.tiles[{
			locationX,
			locationZ,
		}].pos.y
		position : raylib.Vector3 = {
			locationX,
			height,
			locationZ,
		}
		ent := overworld.create(
			position,
			entityList[i].(json.Object)["sprite"].(string),
			"general",
		)

		for event in entityList[i].(json.Object)["event"].(json.Array) {
			evt : game.EntityEvent
			for cond in event.(json.Object)["conditions"].(json.Array) {
				// TODO
				//event.conditions[cond.(json.Array)[0].(string)] = cond.(json.Array)[0].(string)
			}
			evt.id = event.(json.Object)["id"].(string)
			append(&ent.events, evt)
		}
		game.region.entities[{locationX,locationZ}] = ent^
	}
}

load_events :: proc ( filename : string ) {
	rawfile, errorRaw := os.read_entire_file(filename)
	if !errorRaw {
		debug.log("[ERROR] - Failed to load events file.")
		game.running = false
		return
	}
	jsonfile, errorJson := json.parse(rawfile, .JSON5)
	if errorJson != .None {
		debug.log("[ERROR] - Failed to parse events file.")
		game.running = false
		return
	}

	eventList		:= jsonfile.(json.Object)["events"].(json.Array)
	triggerList		:= jsonfile.(json.Object)["triggers"].(json.Array)
	variableList	:= jsonfile.(json.Object)["variables"].(json.Array)

	//* Events
	for i:=0;i<len(eventList);i+=1 {
		event : game.Event
		event.id = eventList[i].(json.Object)["id"].(string)

		chain := eventList[i].(json.Object)["chain"].(json.Array)
		for n:=0;n<len(chain);n+=1 {
			chn : game.EventChain
			switch chain[n].(json.Array)[0].(string) {
				case "text":
					chn = game.TextEvent{&game.localization[chain[n].(json.Array)[1].(string)]}
				case "warp":
					direction, res := reflect.enum_from_name(game.Direction, chain[n].(json.Array)[4].(string))
					chn = game.WarpEvent{
						entityid = chain[n].(json.Array)[1].(string),
						position = {
							f32(chain[n].(json.Array)[2].(json.Array)[0].(f64)),
							0,
							f32(chain[n].(json.Array)[2].(json.Array)[1].(f64)),
						},
						direction = direction,
						move = chain[n].(json.Array)[3].(bool),
					}
				case "turn":
					direct : game.Direction
					switch chain[n].(json.Array)[2].(string) {
						case "up":		direct = .up
						case "down":	direct = .down
						case "left":	direct = .left
						case "right":	direct = .right
					}
					chn = game.TurnEvent{
						entityid	= chain[n].(json.Array)[1].(string),
						direction	= direct,
					}
				case "move":
					direction : game.Direction = .down
					switch chain[n].(json.Array)[2].(string) {
						case "up":		direction = .up
						case "down":	direction = .down
						case "left":	direction = .left
						case "right":	direction = .right
					}
					chn = game.MoveEvent{
						entityid	= chain[n].(json.Array)[1].(string),
						direction	= direction,
						times		= int(chain[n].(json.Array)[3].(f64)),
						simul		= chain[n].(json.Array)[4].(bool),
					}
				case "wait":
					chn = game.WaitEvent{ int(chain[n].(json.Array)[1].(f64)) }
				case "emote":
					emote : game.Emote
					switch chain[n].(json.Array)[2].(string) {
						case "shocked":		emote = .shocked
						case "confused":	emote = .confused
						case "sad":			emote = .sad
						case "poison":		emote = .poison
					}
					chn = game.EmoteEvent{
						entityid	= chain[n].(json.Array)[1].(string),
						emote		= emote,
						multiplier	= f32(chain[n].(json.Array)[3].(f64)),
						skipwait	= chain[n].(json.Array)[4].(bool),
					}
				case "conditional":
					// TODO: Check this out
					varValue : union{ int, bool, string }
					#partial switch in chain[n].(json.Array)[1].(json.Array)[1] {
						case (f64):		varValue = int(chain[n].(json.Array)[1].(json.Array)[1].(f64))
						case (string):	varValue = chain[n].(json.Array)[1].(json.Array)[1].(string)
						case (bool):	varValue = chain[n].(json.Array)[1].(json.Array)[1].(bool)
					}
					eventType, _ := reflect.enum_from_name(game.ConditionalType, chain[n].(json.Array)[2].(json.Array)[0].(string))
					eventData : union{ int, raylib.Vector2, string } 
					#partial switch eventType {
						case .new_event:	eventData = raylib.Vector2{f32(chain[n].(json.Array)[2].(json.Array)[1].(json.Array)[0].(f64)), f32(chain[n].(json.Array)[2].(json.Array)[1].(json.Array)[1].(f64))}
						case .jump_chain:	eventData = int(chain[n].(json.Array)[2].(json.Array)[1].(f64))
						case .set_chain:	eventData = int(chain[n].(json.Array)[2].(json.Array)[1].(f64))
						case .start_battle:	eventData = chain[n].(json.Array)[2].(json.Array)[1].(string)
					}
					chn = game.ConditionalEvent{
						varName		= chain[n].(json.Array)[1].(json.Array)[0].(string),
						varValue	= varValue,
						eventType	= eventType,
						eventData	= eventData,
					}
				case "setcon":
					vari : union{ int, bool, string }
					#partial switch in chain[n].(json.Array)[2] {
						case (bool):	vari = chain[n].(json.Array)[2].(bool)
						case (f64):		vari = int(chain[n].(json.Array)[2].(f64))
						case (string):	vari = chain[n].(json.Array)[2].(string)
					}
					chn = game.SetConditionalEvent{
						variableName	= chain[n].(json.Array)[1].(string),
						value			= vari,
					}
				case "settile":
					chn = game.SetTileEvent{
						position	= {
							f32(chain[n].(json.Array)[1].(json.Array)[0].(f64)),
							f32(chain[n].(json.Array)[1].(json.Array)[1].(f64)),
						},
						value		= chain[n].(json.Array)[2].(string),
						solid		= chain[n].(json.Array)[3].(bool),
						surf		= chain[n].(json.Array)[4].(bool),
					}
				case "getmonster":
					monster, res := reflect.enum_from_name(game.MonsterSpecies, chain[n].(json.Array)[1].(string))
					if res {
						chn = game.GetMonsterEvent{
							species	= monster,
							level	= int(chain[n].(json.Array)[2].(f64)),
						}
					} else {
						chn = game.GetMonsterEvent{
							species	= .empty,
							level	= 0,
						}
					}
				case "startbattle":
					chn = game.StartBattleEvent{
						id = chain[n].(json.Array)[1].(string),
					}
				case "sound":
					chn = game.PlaySoundEvent{
						name	= chain[n].(json.Array)[1].(string),
						pitch	= f32(chain[n].(json.Array)[2].(f64)),
					}
				case "music":
					chn = game.PlayMusicEvent{
						name	= chain[n].(json.Array)[1].(string),
						pitch	= f32(chain[n].(json.Array)[2].(f64)),
					}
				case "animation":
					texture := raylib.LoadTexture(strings.clone_to_cstring(strings.concatenate({"data/private/sprites/animations/spr_", chain[n].(json.Array)[1].(string), ".png"})))
					list := make([dynamic]int)
					for i in chain[n].(json.Array)[4].(json.Array) do append(&list, int(i.(f64)))
					chn = game.OverlayAnimationEvent{
						texture			= texture,
						length			= int(chain[n].(json.Array)[2].(f64)),
						timer			= int(chain[n].(json.Array)[3].(f64)),
						animation		= list,
						currentFrame	= 0,
						stay			= chain[n].(json.Array)[5].(bool),
					}
				case "choice":
					choiceList := make([dynamic]game.Choice)
					for o:=0;o<int(chain[n].(json.Array)[2].(json.Array)[0].(f64));o+=1 {
						array1 := chain[n].(json.Array)[2].(json.Array)[1].(json.Array)
						array2 := chain[n].(json.Array)[2].(json.Array)[2].(json.Array)
						ev : union{ int, raylib.Vector2 }
						#partial switch in array2[o] {
							case (json.Array):
								ev = raylib.Vector2{
									f32(array2[o].(json.Array)[0].(f64)),
									f32(array2[o].(json.Array)[1].(f64)),
								}
							case (f64):
								ev = int(array2[o].(f64))
						}
						choice : game.Choice = {
							text	= &game.localization[array1[o].(string)],
							event	= ev,
						}
						append(&choiceList, choice)
					}
					chn = game.ChoiceEvent{
						text	= &game.localization[chain[n].(json.Array)[1].(string)],
						choices	= choiceList,
					}
				case "skip":
					chn = game.SkipEvent{
						event	= int(chain[n].(json.Array)[1].(f64)),
					}
			}
			append(&event.chain, chn)
		}
		game.region.events[event.id] = event
	}

	//* Triggers
	for i:=0;i<len(triggerList);i+=1 {
		location : raylib.Vector2 = {
			f32(triggerList[i].(json.Object)["location"].(json.Array)[0].(f64)),
			f32(triggerList[i].(json.Object)["location"].(json.Array)[1].(f64)),
		}
		game.region.triggers[location] = triggerList[i].(json.Object)["event"].(string)
	}

	//* Variables
	for i:=0;i<len(variableList);i+=1 {
		value : union{ int, bool, string }
		#partial switch v in variableList[i].(json.Array)[1] {
			case bool: value = variableList[i].(json.Array)[1].(bool)
			case f64: value = int(variableList[i].(json.Array)[1].(f64))
			case string: value = variableList[i].(json.Array)[1].(string)
		}
		game.eventmanager.eventVariables[variableList[i].(json.Array)[0].(string)] = value
	}
}

load_battles :: proc ( filename : string ) {
	rawfile, errorRaw := os.read_entire_file(filename)
	if !errorRaw {
		debug.log("[ERROR] - Failed to load battles file.")
		game.running = false
		return
	}
	jsonfile, errorJson := json.parse(rawfile, .JSON5)
	if errorJson != .None {
		debug.log("[ERROR] - Failed to parse battles file.")
		game.running = false
		return
	}

	battleList := jsonfile.(json.Object)["battles"].(json.Array)
}

// TODO
close :: proc() {}