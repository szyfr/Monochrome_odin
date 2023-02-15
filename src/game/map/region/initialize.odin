package region


//= Import
import "core:fmt"
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../../../game"
import "../../../game/entity"

import "../../../debug"


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

			//* Entities
			if len(entityList)>count {
				position : raylib.Vector3 = {}
				position.x = f32(entityList[count].(json.Object)["location"].(json.Array)[0].(f64))
				position.z = f32(entityList[count].(json.Object)["location"].(json.Array)[1].(f64))
				position.y = tile.pos.y //TODO
				ent := entity.create(
					entityList[count].(json.Object)["sprite"].(string),
					position,
				)
				//TODO Movement for AI
				game.region.entities[{ent.position.x,ent.position.z}] = ent^
			}

			//* Events //TODO
			if len(eventList)>count {
				position : raylib.Vector3 = {}
				position.x = f32(eventList[count].(json.Object)["location"].(json.Array)[0].(f64))
				position.z = f32(eventList[count].(json.Object)["location"].(json.Array)[1].(f64))
				position.y = tile.pos.y //TODO
				evt : game.Event = {}
				evt.position		= position
				evt.interactable	= ("interact" == eventList[count].(json.Object)["type"].(string))
				
				chain := eventList[count].(json.Object)["chain"].(json.Array)
				for i:=0;i<len(chain);i+=1 {
					chn : game.EventChain
					switch chain[i].(json.Array)[0].(string) {
						case "text":
							chn = &game.localization[chain[i].(json.Array)[1].(string)]
						case "warp":
							chn = raylib.Vector3{
								f32(chain[i].(json.Array)[1].(json.Array)[0].(f64)),
								0,
								f32(chain[i].(json.Array)[1].(json.Array)[1].(f64)),
							}
					}
					append(&evt.chain, chn)
				}
				game.region.events[{evt.position.x,evt.position.z}] = evt
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