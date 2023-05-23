package region


//= Imports
import "core:encoding/json"
import "core:os"

import "vendor:raylib"

import "../../game"
import "../entity"
import "../../debug"


//= Procedures
init :: proc(
	filename : string,
) {
	game.region = new(game.Region)

	rawfile, errorRaw := os.read_entire_file(filename)
	if !errorRaw {
		debug.log("[ERROR] - Failed to load region file.")
		game.running = false
		return
	}

	jsonfile, errorJson := json.parse(rawfile, .JSON5)
	if errorJson != .None {
		debug.log("[ERROR] - Failed to parse region file.")
		game.running = false
		return
	}

	game.region.size.x = f32(jsonfile.(json.Object)["width"].(f64))
	game.region.size.y = f32(jsonfile.(json.Object)["height"].(f64))

	tileList	:= jsonfile.(json.Object)["tiles"].(json.Array)
	entityList	:= jsonfile.(json.Object)["entities"].(json.Array)
	eventList	:= jsonfile.(json.Object)["events"].(json.Array)
	battleList	:= jsonfile.(json.Object)["battles"].(json.Array)

	//* Tiles
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

	//* Events
	for i:=0;i<len(eventList);i+=1 {
		
	}
	//* Entities
	for i:=0;i<len(entityList);i+=1 {
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
		ent := entity.create(
			position,
			entityList[i].(json.Object)["sprite"].(string),
			"general",
		)
		game.region.entities[entityList[i].(json.Object)["id"].(string)] = ent^
	}
}