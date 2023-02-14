package tiles


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../game"


//= Procedures
init :: proc() {
	game.tiles = make(map[string]raylib.Model, 1000)

	count : i32 = 0
	rawDirList := raylib.GetDirectoryFiles("data/tiles", &count)

	for i:=0;i<int(count);i+=1 {
		strExt  := strings.clone_from_cstring(rawDirList[i])
		str, al := strings.remove(strExt, ".obj", 1)
		if strings.contains(str, "tile") || strings.contains(str, "struct") {
			strConc := strings.concatenate({"data/tiles/", strExt})
			game.tiles[str] = raylib.LoadModel(strings.clone_to_cstring(strConc))
		}
	}
	raylib.ClearDirectoryFiles()

	game.tiles["null"] = raylib.LoadModelFromMesh(raylib.GenMeshCube(0,0,0))
}

close :: proc() {
	for model in game.tiles {
		//? For some reason, without this it crashes
		//? It's not really important... But still weird...
		fmt.printf("\n")
		raylib.UnloadModel(game.tiles[model])
	}
}