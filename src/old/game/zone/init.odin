package zone


//= Import
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../../game"
import "../../game/entity"
import "../tiles"
import "../../graphics/sprites"


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

	zone : Zone = {}
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
	for i:=0;i<int(zone.height);i+=1 {
		temp := make([dynamic]tiles.Tile)
		for o:=0;o<int(zone.width);o+=1 {
			ti : tiles.Tile = {}
			ti.model = tileList[(i*int(zone.width))+o].(json.Object)["tile"].(string)
			ti.pos   = {
				f32(o),
				f32(tileList[(i*int(zone.width))+o].(json.Object)["level"].(f64)),
				f32(i),
			}
			ti.solid = tileList[(i*int(zone.width))+o].(json.Object)["solid"].(bool)
			ti.surf  = tileList[(i*int(zone.width))+o].(json.Object)["surf"].(bool)
			append(&temp, ti)
		}
		append(&zone.tiles, temp)
	}

	//* Load entities
	entList := js.(json.Object)["entities"].(json.Array)
	for ent in entList {
	//	entity : game.Entity = {}
	//	entity.position.x = f32(ent.(json.Object)["x"].(f64))
	//	entity.position.z = f32(ent.(json.Object)["z"].(f64))
	//	entity.position.y = zone.tiles[int(entity.position.z)][int(entity.position.x)].pos.y
	//	entity.previous   = entity.position
	//	entity.target     = entity.position
	//	entity.isMoving   = false
	//	entity.isSurfing  = false
	//	entity.direction  = game.Direction(ent.(json.Object)["direction"].(f64))
	//	entity.sprite     = sprites.create(ent.(json.Object)["sprite"].(string))^
		posX := f32(ent.(json.Object)["x"].(f64))
		posZ := f32(ent.(json.Object)["z"].(f64))
		enti := entity.create(
			{
				posX,
				zone.tiles[int(posZ)][int(posX)].pos.y,
				posZ,
			},
			ent.(json.Object)["sprite"].(string),
		)
		//TODO Event
		//TODO Movement for AI
		
		append(&zone.entities, enti)
	}

	zones[zone.name] = zone
}