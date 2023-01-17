package areas


//= Imports
import "core:fmt"
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../tiles"


//= Procedures
init_area :: proc(
	name : string,
) {
	//* Load JSON from file
	raw, er := os.read_entire_file(name)
	js, err := json.parse(raw)

	area : AreaMap = {}
	area.name     = js.(json.Object)["name"].(string)
	area.width    = f32(js.(json.Object)["width"].(f64))
	area.height   = f32(js.(json.Object)["height"].(f64))
	area.position = {
		f32(js.(json.Object)["position"].(json.Object)["x"].(f64)),
		f32(js.(json.Object)["position"].(json.Object)["y"].(f64)),
		f32(js.(json.Object)["position"].(json.Object)["z"].(f64)),
	}

	area.outskirts = js.(json.Object)["outskirts"].(string)

	tileList := js.(json.Object)["tiles"].(json.Array)
	count := 0

	for i:=0;i<int(area.height);i+=1 {
		temp := make([dynamic]tiles.Tile)
		for o:=0;o<int(area.width);o+=1 {
			ti : tiles.Tile = {}
			ti.model = tileList[(i*int(area.width))+o].(json.Object)["tile"].(string)
			ti.pos   = {
				f32(o),
				f32(tileList[(i*int(area.width))+o].(json.Object)["level"].(f64)),
				f32(i),
			}
			ti.solid = tileList[(i*int(area.width))+o].(json.Object)["solid"].(bool)
			ti.surf  = tileList[(i*int(area.width))+o].(json.Object)["surf"].(bool)
			append(&temp, ti)
		}
		append(&area.tilesls2, temp)
	}

	areas[area.name] = area
}