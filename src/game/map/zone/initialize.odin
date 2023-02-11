package zone


//= Import
import "core:fmt"
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../../../game"
import "../../../game/entity"


//= Procedures
init :: proc() {
	init_single("data/maps/mapTest.json")
}

init_single :: proc(
	name : string,
) {
	//* Load JSON
	raw, er := os.read_entire_file(name)
	js, err := json.parse(raw)

	zone : game.Zone = {}
	zone.name     = js.(json.Object)["name"].(string)
	zone.width    = f32(js.(json.Object)["width"].(f64))
	zone.height   = f32(js.(json.Object)["height"].(f64))
	zone.position = {
		f32(js.(json.Object)["position"].(json.Object)["x"].(f64)),
		f32(js.(json.Object)["position"].(json.Object)["y"].(f64)),
		f32(js.(json.Object)["position"].(json.Object)["z"].(f64)),
	}
	zone.outskirts = js.(json.Object)["outskirts"].(string)

	//* Load tiles
	tileList := js.(json.Object)["tiles"].(json.Array)
	count := 0
	for y:=0;y<int(zone.height);y+=1 {
		temp := make([dynamic]game.Tile)
		for x:=0;x<int(zone.width);x+=1 {
			ti : game.Tile = {}
			ti.model = tileList[(y*int(zone.width))+x].(json.Object)["tile"].(string)
			ti.pos   = {
				f32(x),
				f32(tileList[(y*int(zone.width))+x].(json.Object)["level"].(f64)),
				f32(y),
			}
			ti.solid = tileList[(y*int(zone.width))+x].(json.Object)["solid"].(bool)
			ti.surf  = tileList[(y*int(zone.width))+x].(json.Object)["surf"].(bool)
			append(&temp, ti)
		}
		append(&zone.tiles, temp)
	}

	//* Load entities
	entList := js.(json.Object)["entities"].(json.Array)
	for ent in entList {
		position : raylib.Vector3 = {}
		position.x = f32(ent.(json.Object)["location"].(json.Array)[0].(f64))
		position.z = f32(ent.(json.Object)["location"].(json.Array)[1].(f64))
		position.y = zone.tiles[int(position.z)][int(position.x)].pos.y

		enti := entity.create(
			ent.(json.Object)["sprite"].(string),
			position,
		)
		//TODO Movement for AI
		
		append(&zone.entities, enti^)
	}
	
	//TODO Events
	evtList := js.(json.Object)["events"].(json.Array)
	for evt in evtList {
		event : game.Event = {}
		switch evt.(json.Object)["type"].(string) {
			case "warp":
				//* Location
				location : raylib.Vector2
				location.x		= f32(evt.(json.Object)["location"].(json.Array)[0].(f64))
				location.y		= f32(evt.(json.Object)["location"].(json.Array)[1].(f64))
				event.location	= location

				//* Type
				event.type		= .warp

				//* Data
				target   : raylib.Vector2
				target.x		= f32(evt.(json.Object)["warp"].(json.Array)[0].(f64))
				target.y		= f32(evt.(json.Object)["warp"].(json.Array)[1].(f64))
				event.data		= target

			case "interact":
				//* Location
				location : raylib.Vector2
				location.x		= f32(evt.(json.Object)["location"].(json.Array)[0].(f64))
				location.y		= f32(evt.(json.Object)["location"].(json.Array)[1].(f64))
				event.location	= location

				//* Type
				event.type		= .interact
				
				//* Data
				//event.data			= 
		}
		zone.events[event.location.(raylib.Vector2)] = event
		//append(&zone.events, event)
	}

	game.zones[zone.name] = zone
}

close :: proc() {
	delete(game.zones)
}