package tiles


//= Import
import "core:fmt"
import "core:strings"

import "vendor:raylib"


//= Procedures
init :: proc() {
	count : i32 = 0
	rawDirList := raylib.GetDirectoryFiles("data/tiles", &count)

	for i:=0;i<int(count);i+=1 {
		strExt  := strings.clone_from_cstring(rawDirList[i])
		str, al := strings.remove(strExt, ".obj", 1)
		if strings.contains(str, "tile") || strings.contains(str, "struct") {
			strConc := strings.concatenate({"data/tiles/", strExt})
			data[str] = raylib.LoadModel(strings.clone_to_cstring(strConc))
		}
	}
	raylib.ClearDirectoryFiles()

	data["null"] = raylib.LoadModelFromMesh(raylib.GenMeshCube(0,0,0))
}

close :: proc() {
	for model in data {
		//? For some reason, without this it crashes
		//? It's not really important... But still weird...
		fmt.printf("\n")
		raylib.UnloadModel(data[model])
	}
}