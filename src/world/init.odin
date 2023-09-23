package world


//= Imports
import "core:fmt"
import "core:strings"
import "core:math"
import "core:os"
import "core:reflect"
import "core:encoding/json"

import "vendor:raylib"

import "../camera"
import "../graphics"
import "../data"
import "../debug"


//= Constants
OFFSET :: 10
DEPTH  :: 20
WIDTH  :: 20
HEIGHT :: 10


//= Procedures
init_tiles :: proc() {
	directoryList := raylib.LoadDirectoryFilesEx("data/tiles", ".obj", false)

	for i:u32=0;i<directoryList.count;i+=1 {
		str, _ := strings.remove_all(strings.clone_from_cstring(directoryList.paths[i]), ".obj")
		str, _  = strings.remove_all(str, "data/tiles/")
		data.worldData.models[str] = raylib.LoadModel(directoryList.paths[i])
	}

	raylib.UnloadDirectoryFiles(directoryList)
}

close_tiles :: proc() {
	for i in data.worldData.models do delete_key(&data.worldData.models, i)
}

init_map :: proc( mapName : string ) {
	//* Check for file and load
	if !os.is_file(mapName) {
		debug.logf("[WARNING] - Failed to find '%v'.", mapName)
		return
	}
	file, _ := os.read_entire_file(mapName)
	fileJson, _ := json.parse(file)

	//* Parse json
	tilesRoot := fileJson.(json.Object)["tiles"].(json.Array)
	for i:=0;i<len(tilesRoot);i+=1 {
		solidArr : [4]bool = parse_solid(tilesRoot[i].(json.Object)["tags"].(json.Array)[0].(json.Array))
		tile : data.Tile = {
			strings.clone(tilesRoot[i].(json.Object)["tile"].(string)),
			solidArr,
			tilesRoot[i].(json.Object)["tags"].(json.Array)[1].(bool),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[2].(bool),
		}
		position : raylib.Vector3 = {
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[0].(f64)),
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[1].(f64)),
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[2].(f64)),
		}
		data.worldData.currentMap[position] = tile
	}

	//* Cleanup
	json.destroy_value(fileJson)
	delete(file)
}

parse_solid :: proc( arr : json.Array ) -> [4]bool {
	output : [4]bool = {false,false,false,false}

	for i:=0;i<len(arr);i+=1 {
		switch arr[i].(string) {
			case "all":   output = {true,true,true,true}
			case "none":  output = {false,false,false,false}
			case "north": output[0] = true
			case "west":  output[1] = true
			case "south": output[2] = true
			case "east":  output[3] = true
		}
	}
	return output
}
