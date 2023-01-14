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
	area.name  = js.(json.Object)["name"].(string)
	area.width = f32(js.(json.Object)["width"].(f64))

	//area.outskirts = &tiles.data[js.(json.Object)["outskirts"].(string)]
	area.outskirts = js.(json.Object)["outskirts"].(string)

	tileList := js.(json.Object)["tiles"].(json.Array)

	for tile in tileList {
		ti : tiles.Tile = {}
		//ti.model = &tiles.data[tile.(json.Object)["tile"].(string)]
		ti.model = tile.(json.Object)["tile"].(string)
		ti.level = f32(tile.(json.Object)["level"].(f64))
		ti.solid = tile.(json.Object)["solid"].(bool)
		ti.surf  = tile.(json.Object)["surf"].(bool)

		fmt.printf("%v\n", ti)

		append(&area.tiles, ti)
	}

	areas[area.name] = area

	//fmt.printf("%v\n", js.(json.Object)["outskirts"].(string))
}