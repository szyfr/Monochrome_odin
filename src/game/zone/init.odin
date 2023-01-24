package zone


//= Import
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../tiles"


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

	zones[zone.name] = zone
}