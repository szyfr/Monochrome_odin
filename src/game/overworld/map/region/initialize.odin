package region


//= Import
import "core:fmt"
import "core:os"
import "core:encoding/json"
import "core:reflect"
import "core:math"
import "core:strings"

import "vendor:raylib"

import "../../../../game"
import "../../entity"
import "../../../../game/battle/monsters"

import "../../../../debug"


//= Constants
REGION_ERROR_FILE_CRIT  :: "[ERROR][CRITICAL]\t- Failed to load region file."
REGION_ERROR_PARSE_CRIT :: "[ERROR][CRITICAL]\t- Failed to load region file."


//= Procedures
init :: proc(
	filename : string,
) {
	game.region = new(game.Region)

	rawfile, errraw	:= os.read_entire_file(filename)

	if !errraw {
		debug.add_to_log(REGION_ERROR_FILE_CRIT)
		game.running = false
	}

	jsonfile, errjs	:= json.parse(rawfile, .JSON5)

	if errjs != .None && errjs != .EOF {
		debug.add_to_log(REGION_ERROR_PARSE_CRIT)
		game.running = false
	}

	game.region.size.x = f32(jsonfile.(json.Object)["width"].(f64))
	game.region.size.y = f32(jsonfile.(json.Object)["height"].(f64))

	tileList	:= jsonfile.(json.Object)["tiles"].(json.Array)
	entityList	:= jsonfile.(json.Object)["entities"].(json.Array)
	eventList	:= jsonfile.(json.Object)["events"].(json.Array)
	battleList	:= jsonfile.(json.Object)["battles"].(json.Array)
	for y:=0;y<int(game.region.size.y);y+=1 {
		for x:=0;x<int(game.region.size.x);x+=1 {
			count := (y*int(game.region.size.x))+x

			//* Tiles
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

			//* Events
			if len(eventList)>count {
				position : raylib.Vector3 = {}
				position.x = f32(eventList[count].(json.Object)["location"].(json.Array)[0].(f64))
				position.z = f32(eventList[count].(json.Object)["location"].(json.Array)[1].(f64))
				positionCalc := int(position.x) % int(game.region.size.x) + (int(position.z) * int(game.region.size.x))
				position.y = f32(tileList[positionCalc].(json.Object)["level"].(f64))
				evt : game.Event = {}
				evt.position		= position
				evt.interactable	= ("interact" == eventList[count].(json.Object)["type"].(string))

				arr := eventList[count].(json.Object)["conditional"].(json.Array)
				if len(arr) > 0 {
					for member in arr {
						evt.conditional[member.(json.Array)[0].(string)] = member.(json.Array)[1].(bool)
					}
				}
				
				chain := eventList[count].(json.Object)["chain"].(json.Array)
				for i:=0;i<len(chain);i+=1 {
					chn : game.EventChain
					switch chain[i].(json.Array)[0].(string) {
						case "text":
							chn = game.TextEvent{&game.localization[chain[i].(json.Array)[1].(string)]}

						case "warp":
							direction, res := reflect.enum_from_name(game.Direction, chain[i].(json.Array)[4].(string))
							chn = game.WarpEvent{
								entityid = chain[i].(json.Array)[1].(string),
								position = {
									f32(chain[i].(json.Array)[2].(json.Array)[0].(f64)),
									0,
									f32(chain[i].(json.Array)[2].(json.Array)[1].(f64)),
								},
								direction = direction,
								move = chain[i].(json.Array)[3].(bool),
							}

						case "turn":
							direct : game.Direction
							switch chain[i].(json.Array)[2].(string) {
								case "up":		direct = .up
								case "down":	direct = .down
								case "left":	direct = .left
								case "right":	direct = .right
							}
							chn = game.TurnEvent{
								entityid	= chain[i].(json.Array)[1].(string),
								direction	= direct,
							}

						case "move":
							direction : game.Direction = .down
							switch chain[i].(json.Array)[2].(string) {
								case "up":		direction = .up
								case "down":	direction = .down
								case "left":	direction = .left
								case "right":	direction = .right
							}
							chn = game.MoveEvent{
								entityid	= chain[i].(json.Array)[1].(string),
								direction	= direction,
								times		= int(chain[i].(json.Array)[3].(f64)),
								simul		= chain[i].(json.Array)[4].(bool),
							}

						case "wait":
							chn = game.WaitEvent{ int(chain[i].(json.Array)[1].(f64)) }

						case "emote":
							emote : game.Emote
							switch chain[i].(json.Array)[2].(string) {
								case "shocked":		emote = .shocked
								case "confused":	emote = .confused
								case "sad":			emote = .sad
								case "poison":		emote = .poison
							}
							chn = game.EmoteEvent{
								entityid	= chain[i].(json.Array)[1].(string),
								emote		= emote,
								multiplier	= f32(chain[i].(json.Array)[3].(f64)),
								skipwait	= chain[i].(json.Array)[4].(bool),
							}

						case "conditional":
							condEvent : union{ int, raylib.Vector2 }
							#partial switch in chain[i].(json.Array)[3] {
								case (f64):			condEvent = int(chain[i].(json.Array)[3].(f64))
								case (json.Array):	condEvent = raylib.Vector2{
									f32(chain[i].(json.Array)[3].(json.Array)[0].(f64)),
									f32(chain[i].(json.Array)[3].(json.Array)[1].(f64)),
								}
							}
							chn = game.ConditionalEvent{
								variableName	= chain[i].(json.Array)[1].(string),
								value			= chain[i].(json.Array)[2].(bool),
								event			= condEvent,
							}
						
						case "setcon":
							chn = game.SetConditionalEvent{
								variableName	= chain[i].(json.Array)[1].(string),
								value			= chain[i].(json.Array)[2].(bool),
							}

						case "settile":
							chn = game.SetTileEvent{
								position	= {
									f32(chain[i].(json.Array)[1].(json.Array)[0].(f64)),
									f32(chain[i].(json.Array)[1].(json.Array)[1].(f64)),
								},
								value		= chain[i].(json.Array)[2].(string),
								solid		= chain[i].(json.Array)[3].(bool),
								surf		= chain[i].(json.Array)[4].(bool),
							}
						
						case "getpokemon":
							pokemon, res := reflect.enum_from_name(game.PokemonSpecies, chain[i].(json.Array)[1].(string))
							if res {
								chn = game.GetPokemonEvent{
									species	= pokemon,
									level	= int(chain[i].(json.Array)[2].(f64)),
								}
							} else {
								chn = game.GetPokemonEvent{
									species	= .empty,
									level	= 0,
								}
							}
						
						case "startbattle":
							chn = game.StartBattleEvent{
								id = chain[i].(json.Array)[1].(string),
							}

						case "sound":
							chn = game.PlaySoundEvent{
								name	= chain[i].(json.Array)[1].(string),
								pitch	= f32(chain[i].(json.Array)[2].(f64)),
							}
						case "music":
							chn = game.PlayMusicEvent{
								name	= chain[i].(json.Array)[1].(string),
								pitch	= f32(chain[i].(json.Array)[2].(f64)),
							}
						case "animation":
							texture := raylib.LoadTexture(strings.clone_to_cstring(strings.concatenate({"data/sprites/animations/spr_", chain[i].(json.Array)[1].(string), ".png"})))
							list := make([dynamic]int)
							for i in chain[i].(json.Array)[4].(json.Array) do append(&list, int(i.(f64)))
							chn = game.OverlayAnimationEvent{
								texture			= texture,
								length			= int(chain[i].(json.Array)[2].(f64)),
								timer			= int(chain[i].(json.Array)[3].(f64)),
								animation		= list,
								currentFrame	= 0,
								stay			= chain[i].(json.Array)[5].(bool),
							}
						case "choice":
							choiceList := make([dynamic]game.Choice)
							for o:=0;o<int(chain[i].(json.Array)[2].(json.Array)[0].(f64));o+=1 {
								array1 := chain[i].(json.Array)[2].(json.Array)[1].(json.Array)
								array2 := chain[i].(json.Array)[2].(json.Array)[2].(json.Array)
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
								text	= &game.localization[chain[i].(json.Array)[1].(string)],
								choices	= choiceList,
							}

						case "skip":
							chn = game.SkipEvent{
								event	= int(chain[i].(json.Array)[1].(f64)),
							}

					}
					append(&evt.chain, chn)
				}
				game.region.events[{evt.position.x,evt.position.z}] = evt
			}

			//* Entities
			if len(entityList)>count {
				position : raylib.Vector3 = {}
				position.x = f32(entityList[count].(json.Object)["location"].(json.Array)[0].(f64))
				position.z = f32(entityList[count].(json.Object)["location"].(json.Array)[1].(f64))
				positionCalc := int(position.x) % int(game.region.size.x) + (int(position.z) * int(game.region.size.x))
				position.y = f32(tileList[positionCalc].(json.Object)["level"].(f64))
				ent := entity.create(
					entityList[count].(json.Object)["sprite"].(string),
					position,
				)
				ent.interactionEvent = {
					f32(entityList[count].(json.Object)["event"].(json.Array)[0].(f64)),
					f32(entityList[count].(json.Object)["event"].(json.Array)[1].(f64)),
				}
				ent.id = entityList[count].(json.Object)["id"].(string)
				direction : game.Direction

				arr := entityList[count].(json.Object)["conditional"].(json.Array)
				if len(arr) > 0 {
					for member in arr {
						ent.conditional[member.(json.Array)[0].(string)] = member.(json.Array)[1].(bool)
					}
				}

				switch entityList[count].(json.Object)["direction"].(string) {
					case "up":		direction = .up
					case "down":	direction = .down
					case "left":	direction = .left
					case "right":	direction = .right
				}
				entity.turn(ent, direction)
				//TODO Movement for AI
				game.region.entities[{ent.position.x,ent.position.z}] = ent^
			}

			//* Battles
			if len(battleList)>count {
				arena, res := reflect.enum_from_name(game.Arena, battleList[count].(json.Object)["arena"].(string))

				btl : game.BattleData	= {}
				btl.id				= battleList[count].(json.Object)["id"].(string)
				btl.trainerName		= battleList[count].(json.Object)["trainer"].(string)
				btl.arena			= arena
				btl.pokemonNormal	= load_pokemon(battleList[count].(json.Object)["mon_normal"].(json.Array))
				btl.pokemonHard		= load_pokemon(battleList[count].(json.Object)["mon_hard"].(json.Array))
				game.battles[btl.id] = btl
			}
		}
	}
}

close :: proc() {
	delete(game.region.tiles)
	delete(game.region.entities)
	delete(game.region.events)
	free(game.region)
}

load_pokemon :: proc(
	input : json.Array,
) -> [4]game.Pokemon {
	output : [4]game.Pokemon
	for i in 0..<4 {
		pokemon, res := reflect.enum_from_name(game.PokemonSpecies, input[i].(json.Array)[0].(string))
		if pokemon == .empty do break

		pkmn : game.Pokemon = monsters.create(pokemon, int(input[i].(json.Array)[1].(f64)))
		//pkmn.experience = int(math.pow(input[i].(json.Array)[1].(f64), 3))
		for o in 0..<4 {
			attack, resu := reflect.enum_from_name(game.PokemonAttack, input[i].(json.Array)[3+o].(string))
			pkmn.attacks[o] = {attack, 0}
		}
		output[i] = pkmn
	}

	return output
}