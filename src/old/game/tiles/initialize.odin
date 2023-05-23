package tiles


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../debug"


//= Procedures
init :: proc() {
	game.tiles = make(map[string]raylib.Model, 1000)
	game.tilesTest = make(map[string]raylib.Mesh, 1000)

	filePath := ""
	if os.exists("data/private/tiles/") do filePath = "data/private/tiles"
	else if os.exists("data/core/tiles/") do filePath = "data/core/tiles"
	else {
		debug.log("[ERROR] - Failed to find tiles directory.")
		game.running = false
		return
	}

	rawDirectoryList := raylib.LoadDirectoryFiles(strings.clone_to_cstring(filePath))

	for i:=2;i<int(rawDirectoryList.count);i+=1 {
		strExtension := strings.clone_from_cstring(rawDirectoryList.paths[i])
		if strings.contains(strExtension, "tile_") {
			model := raylib.LoadModel(strings.clone_to_cstring(strExtension))

			str, _ := strings.remove(strExtension, ".obj", 1)
			str, _  = strings.remove(str, ".gltf", 1)
			str, _  = strings.remove(str, "data/core/tiles/", 1)
		//	fmt.printf("%v\n",str)
			game.tiles[str] = model
			game.tilesTest[str] = model.meshes[0]
		}
	}
	//TODO Load textures?
	game.tilesMaterial		= raylib.LoadMaterialDefault()
	game.tilesTexture		= raylib.LoadTexture("data/core/tiles/texture_0.png")
	//game.tilesTexture[1]	= raylib.LoadTexture("data/tiles/texture_1.png")
	//game.tilesTexture[2]	= raylib.LoadTexture("data/tiles/texture_2.png")
	//game.tilesTexture[3]	= raylib.LoadTexture("data/tiles/texture_3.png")
	//game.tilesTexture[4]	= raylib.LoadTexture("data/tiles/texture_4.png")
	//game.tilesTexture[5]	= raylib.LoadTexture("data/tiles/texture_5.png")
	//game.tilesTexture[6]	= raylib.LoadTexture("data/tiles/texture_6.png")
	//game.tilesTexture[7]	= raylib.LoadTexture("data/tiles/texture_7.png")
	raylib.SetMaterialTexture(&game.tilesMaterial, .ALBEDO, game.tilesTexture)

	raylib.UnloadDirectoryFiles(rawDirectoryList)
}

close :: proc() {
	for model in game.tiles {
		raylib.UnloadModel(game.tiles[model])
		delete_key(&game.tiles, model)
	}
}