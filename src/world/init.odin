package world


//= Imports
import "core:fmt"
import "core:strings"
import "core:math"
import "core:os"
import "core:encoding/json"

import "vendor:raylib"

import "../player"
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
		models[str] = raylib.LoadModel(directoryList.paths[i])
	}

	raylib.UnloadDirectoryFiles(directoryList)
}

close_tiles :: proc() {
	for i in models do delete_key(&models, i)
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
		tile : data.Tile = {
			strings.clone(tilesRoot[i].(json.Object)["tile"].(string)),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[0].(bool),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[1].(bool),
			tilesRoot[i].(json.Object)["tags"].(json.Array)[2].(bool),
		}
		position : raylib.Vector3 = {
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[0].(f64)),
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[1].(f64)),
			f32(tilesRoot[i].(json.Object)["position"].(json.Array)[2].(f64)),
		}
		currentMap[position] = tile
	}

	//* Cleanup
	json.destroy_value(fileJson)
	delete(file)
}

draw :: proc() {
	//for tile in currentMap {
	//	model := &models[currentMap[tile].model]
	//	raylib.DrawModelEx(
	//		model^,
	//		tile,
	//		{0,1,0},
	//		0,
	//		{1,1,1},
	//		raylib.WHITE,
	//	)
	//}
	
	//* Initialize all variables
	//maxX, minX := int(player.unit.position.x) + WIDTH,  int(player.unit.position.x) - WIDTH
	//maxY, minY := int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	//maxZ, minZ := int(player.unit.position.z) + DEPTH,  int(player.unit.position.z) - DEPTH

	//maxX, minX : int
	//maxY, minY : int
	//maxZ, minZ : int
//
	//switch camera.trgRotation {
	//	case 360: fallthrough
	//	case   0:
	//		maxX, minX = int(player.unit.position.x) + WIDTH,  int(player.unit.position.x) - WIDTH
	//		maxY, minY = int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	//		maxZ, minZ = int(player.unit.position.z) + DEPTH,  int(player.unit.position.z) - DEPTH
	//	case  90:
	//		maxX, minX = int(player.unit.position.z) + WIDTH,  int(player.unit.position.z) - WIDTH
	//		maxY, minY = int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	//		maxZ, minZ = int(player.unit.position.x) + DEPTH,  int(player.unit.position.x) - DEPTH
	//	case 180:
	//		maxX, minX = int(player.unit.position.x) + WIDTH,  int(player.unit.position.x) - WIDTH
	//		maxY, minY = int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	//		maxZ, minZ = int(player.unit.position.z) + DEPTH,  int(player.unit.position.z) - DEPTH
	//	case -90: fallthrough
	//	case 270:
	//		maxX, minX = int(player.unit.position.z) + WIDTH,  int(player.unit.position.z) - WIDTH
	//		maxY, minY = int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	//		maxZ, minZ = int(player.unit.position.x) + DEPTH,  int(player.unit.position.x) - DEPTH
	//}
//
//
	//width  := maxX - minX
	//height := maxY - minY
	//depth  := maxZ - minZ
	//col : raylib.Color = {0,0,0,255}
//
	//for y:=minY;y<maxY;y+=1 {
	//	for z:=minZ;z<maxZ;z+=1 {
	//		x := minX
	//		flip := false
//
	//		for c:=0;c!=width;c+=1 {
	//			//* Grab model
	//			tile, resTile := currentMap[{f32(x),f32(y),f32(z)}]
	//			if resTile {
	//				model, resModel := models[tile.model]
	//				if resModel {
	//					raylib.DrawModelEx(
	//						model,
	//						{f32(x),f32(y),f32(z)},
	//						{0,1,0},
	//						0,
	//						{1,1,1},
	//						raylib.WHITE,
	//					)
	//				}
	//			}
	//			if !flip do x += 1
	//			else     do x -= 1
//
	//			if x >= int(player.unit.position.x) && !flip {
	//				flip = true
	//				x = maxX-1
	//			}
	//		}
//
	//		//* Entities
	//	}
	//}

	//* Initialize all variables
	maxX, minX := int(player.unit.position.x) + WIDTH,  int(player.unit.position.x) - WIDTH
	maxY, minY := int(player.unit.position.y) + HEIGHT, int(player.unit.position.y) - HEIGHT
	maxZ, minZ := int(player.unit.position.z) + DEPTH,  int(player.unit.position.z) - DEPTH

	width  := maxX - minX
	height := maxY - minY
	depth  := maxZ - minZ
	col : raylib.Color = {0,0,0,255}

	for y:=minY;y<maxY;y+=1 {
		switch camera.trgRotation {
			case 360: fallthrough
			case   0: draw_line_000(y, width, minX, maxX, minZ, maxZ)
			case  90: draw_line_090(y, depth, minX, maxX, minZ, maxZ)
			case 180: draw_line_180(y, width, minX, maxX, minZ, maxZ)
				//for z:=maxZ;z>minZ;z-=1 {
				//	x := maxX
				//	flip := false
				//	for c:=0;c!=width;c+=1 {
				//		tile, resTile := currentMap[{f32(x),f32(y),f32(z)}]
				//		//fmt.printf("")
				//		if resTile {
				//			model, resModel := models[tile.model]
				//			if resModel {
				//				raylib.DrawModelEx(
				//					model,
				//					{f32(x),f32(y),f32(z)},
				//					{0,1,0},
				//					0,
				//					{1,1,1},
				//					raylib.WHITE,
				//				)
				//			}
				//		}
				//		if !flip do x -= 1
				//		else     do x += 1
				//		if x <= int(player.unit.position.x) && !flip {
				//			flip = true
				//			x = minX+1
				//		}
				//	}
				//}
		}
	}
}

draw_line_000 :: proc( y : int, width : int, minX, maxX, minZ, maxZ : int ) {
	for z:=minZ;z<maxZ;z+=1 {
		x := minX
		flip := false

		for c:=0;c!=width;c+=1 {
			tile, resTile := currentMap[{f32(x),f32(y),f32(z)}]
			if resTile {
				model, resModel := models[tile.model]
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						0,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do x += 1
			else     do x -= 1

			if x >= int(player.unit.position.x) && !flip {
				flip = true
				x = maxX-1
			}
		}
	}
}

draw_line_090 :: proc( y : int, depth : int, minX, maxX, minZ, maxZ : int ) {
	for x:=maxX;x>minX;x-=1 {
		z := minZ
		flip := false
		for c:=0;c!=depth;c+=1 {
			tile, resTile := currentMap[{f32(x),f32(y),f32(z)}]
			if resTile {
				model, resModel := models[tile.model]
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						0,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do z += 1
			else     do z -= 1
			if z > int(player.unit.position.x) && !flip {
				flip = true
				z = maxZ-1
			}
		}
	}
}

draw_line_180 :: proc( y : int, width : int, minX, maxX, minZ, maxZ : int ) {
	for z:=minZ;z<maxZ;z+=1 {
		x := minX
		flip := false
		for c:=0;c!=width;c+=1 {
			tile, resTile := currentMap[{f32(x),f32(y),f32(z)}]
			if resTile {
				model, resModel := models[tile.model]
				if resModel {
					raylib.DrawModelEx(
						model,
						{f32(x),f32(y),f32(z)},
						{0,1,0},
						90,
						{1,1,1},
						raylib.WHITE,
					)
				}
			}
			if !flip do x -= 1
			else     do x += 1
			if x < int(player.unit.position.x) && !flip {
				flip = true
				x = minX-1
			}
		}
	}
}