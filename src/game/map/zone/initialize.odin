package zone


//= Import
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../../../game"
import "../../../game/entity"
//import "../tiles"
//import "../../graphics/sprites"


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
		posX := f32(ent.(json.Object)["x"].(f64))
		posZ := f32(ent.(json.Object)["z"].(f64))
		enti := entity.create(
			ent.(json.Object)["sprite"].(string),
			{
				posX,
				zone.tiles[int(posZ)][int(posX)].pos.y,
				posZ,
			},
		)
		//TODO Movement for AI
		
		append(&zone.entities, enti^)
	}
	
	//TODO Event

	game.zones[zone.name] = zone
}

close :: proc() {
	delete(game.zones)
}