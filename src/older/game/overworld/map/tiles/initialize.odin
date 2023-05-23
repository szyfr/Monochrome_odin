package tiles


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../../game"


//= Procedures
init :: proc() {
	game.tiles = make(map[string]raylib.Model, 1000)

	count : i32 = 0
	rawDirList := raylib.GetDirectoryFiles("data/tiles", &count)

	for i:=2;i<int(count);i+=1 {
		strExt  := strings.clone_from_cstring(rawDirList[i])
		strConc := strings.concatenate({"data/tiles/", strExt})
		if strings.contains(strExt, "tile") {
			model := raylib.LoadModel(strings.clone_to_cstring(strConc))

			str, al := strings.remove(strExt, ".obj", 1)
			game.tiles[str] = model
			game.tilesTest[str] = model.meshes[0]
		}
	}
	game.tilesMaterial		= raylib.LoadMaterialDefault()
	game.tilesTexture[0]	= raylib.LoadTexture("data/tiles/texture_0.png")
	game.tilesTexture[1]	= raylib.LoadTexture("data/tiles/texture_1.png")
	game.tilesTexture[2]	= raylib.LoadTexture("data/tiles/texture_2.png")
	game.tilesTexture[3]	= raylib.LoadTexture("data/tiles/texture_3.png")
	game.tilesTexture[4]	= raylib.LoadTexture("data/tiles/texture_4.png")
	game.tilesTexture[5]	= raylib.LoadTexture("data/tiles/texture_5.png")
	game.tilesTexture[6]	= raylib.LoadTexture("data/tiles/texture_6.png")
	game.tilesTexture[7]	= raylib.LoadTexture("data/tiles/texture_7.png")
	raylib.SetMaterialTexture(&game.tilesMaterial, .ALBEDO, game.tilesTexture[0])

	raylib.ClearDirectoryFiles()
}

close :: proc() {
	for model in game.tiles {
		//? For some reason, without this it crashes
		//? It's not really important... But still weird...
		fmt.printf("\n")
		raylib.UnloadModel(game.tiles[model])
	}
}