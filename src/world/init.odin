package world


//= Imports
import "core:fmt"
import "core:strings"
import "core:math"
import "core:os"
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
			f32(tilesRoot[i].(json.Object)["tags"].(json.Array)[1].(f64)),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[2].(bool),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[3].(bool),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[4].(bool),
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

draw :: proc() {
	using data

	//* Initialize all variables
	playerPosition := playerData.unit.position
	maxX, minX := int(playerPosition.x) + WIDTH,  int(playerPosition.x) - WIDTH
	maxY, minY := int(playerPosition.y) + HEIGHT, int(playerPosition.y) - HEIGHT
	maxZ, minZ := int(playerPosition.z) + DEPTH,  int(playerPosition.z) - DEPTH
	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ
	col : raylib.Color = {0,0,0,255}

	//* Draw from bottom up
	for y:=f32(minY);y<f32(maxY);y+=0.5 {
		//* Change order of drawing based on the current direction of camera rotation
		switch {
			case (cameraData.rotation > -45 && cameraData.rotation <=  45) || (cameraData.rotation > 315 && cameraData.rotation <= 405):
				draw_line_000(y, width, minX, maxX, minZ, maxZ, playerPosition.x)
			case cameraData.rotation >  45 && cameraData.rotation <= 135:
				draw_line_090(y, depth, minX, maxX, minZ, maxZ, playerPosition.z)
			case cameraData.rotation > 135 && cameraData.rotation <= 225:
				draw_line_180(y, width, minX, maxX, minZ, maxZ, playerPosition.x)
			case (cameraData.rotation > 225 && cameraData.rotation <= 315) || (cameraData.rotation > -135 && cameraData.rotation <= -45):
				draw_line_270(y, depth, minX, maxX, minZ, maxZ, playerPosition.z)
		}
	}
}

// TODO Add entity rendering into draw lines

draw_line_000 :: proc( y : f32, width : int, minX, maxX, minZ, maxZ : int, playerPos : f32 ) {
	for z:=minZ;z<maxZ;z+=1 {
		x := minX
		flip := false

		for c:=0;c!=width;c+=1 {
			tile, resTile := data.worldData.currentMap[{f32(x),y,f32(z)}]
			if resTile {
				model, resModel := data.worldData.models[tile.model]
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						-360,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do x += 1
			else     do x -= 1

			if x >= int(playerPos) && !flip {
				flip = true
				x = maxX-1
			}
		}
	}
}

draw_line_090 :: proc( y : f32, depth : int, minX, maxX, minZ, maxZ : int, playerPos : f32 ) {
	for x:=maxX;x>minX;x-=1 {
		z := maxZ
		flip := false
		for c:=0;c!=depth;c+=1 {
			tile, resTile := data.worldData.currentMap[{f32(x),y,f32(z)}]
			if resTile {
				model, resModel := data.worldData.models[tile.model]
				rotation : f32 = 0
				if tile.trnsp do rotation = -90
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						rotation,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do z -= 1
			else     do z += 1
			if z <= int(playerPos) && !flip {
				flip = true
				z = minZ+1
			}
		}
	}
}

draw_line_180 :: proc( y : f32, width : int, minX, maxX, minZ, maxZ : int, playerPos : f32 ) {
	for z:=maxZ;z>minZ;z-=1 {
		x := maxX
		flip := false
		for c:=0;c!=width;c+=1 {
			tile, resTile := data.worldData.currentMap[{f32(x),y,f32(z)}]
			if resTile {
				model, resModel := data.worldData.models[tile.model]
				rotation : f32 = 0
				if tile.trnsp do rotation = -180
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						rotation,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do x -= 1
			else     do x += 1
			if x <= int(playerPos) && !flip {
				flip = true
				x = minX+1
			}
		}
	}
}

draw_line_270 :: proc( y : f32, depth : int, minX, maxX, minZ, maxZ : int, playerPos : f32 ) {
	for x:=minX;x<maxX;x+=1 {
		z := minZ
		flip := false
		for c:=0;c!=depth;c+=1 {
			tile, resTile := data.worldData.currentMap[{f32(x),y,f32(z)}]
			if resTile {
				model, resModel := data.worldData.models[tile.model]
				rotation : f32 = 0
				if tile.trnsp do rotation = -270
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						rotation,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do z += 1
			else     do z -= 1
			if z >= int(playerPos) && !flip {
				flip = true
				z = maxZ-1
			}
		}
	}
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
