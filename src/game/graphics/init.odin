package graphics


//= Imports
import "core:fmt"
import "core:os"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../game"


//= Procedures
init :: proc() {
	//* Textbox
	img := raylib.LoadImage("data/core/sprites/ui/textbox.png")
	raylib.ImageResizeNN(&img, img.width * 4, img.height * 4)
	game.boxUI = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	size := game.boxUI.width / 3
	game.boxUI_npatch = {
		{ 0, 0, f32(game.boxUI.width), f32(game.boxUI.height)},
		size,size,size,size,
		.NINE_PATCH,
	}

	//* MonsterBox
	img = raylib.LoadImage("data/core/sprites/ui/spr_monster_info.png")
	raylib.ImageResizeNN(&img, img.width * 4, img.height * 4)
	game.monsterBox = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	//* Font
	game.font = raylib.LoadFont("data/core/sprites/ui/font.ttf")

	//* Pointer
	game.pointer = raylib.LoadTexture("data/core/sprites/ui/spr_pointer.png")

	//* Emotes
	game.emotes = raylib.LoadImage("data/private/sprites/overworld/spr_emotes.png")
	game.emoteMeshDef = raylib.GenMeshPlane(0.75,0.75,1,1)

	for i:=0;i<8;i+=1 {
		game.emoteMaterials[i] = raylib.LoadMaterialDefault()
		img	:= raylib.ImageFromImage(game.emotes,{f32(i)*16,0,16,16})
		game.emoteMaterials[i].maps[0].texture = raylib.LoadTextureFromImage(img)
		raylib.UnloadImage(img)
	}
	
	//* Standee mesh
	game.standeeMesh = raylib.GenMeshPlane(1,1,1,1)

	//* Tiles
	game.tiles = make(map[string]raylib.Model, 1000)

	// TODO: possibly make it also import from private?
	filepath := "data/core/tiles"
	rawDirectoryList := raylib.LoadDirectoryFiles(strings.clone_to_cstring(filepath))
	
	for i:=2;i<int(rawDirectoryList.count);i+=1 {
		strExtension := strings.clone_from_cstring(rawDirectoryList.paths[i])
		if strings.contains(strExtension, "tile_") {
			model := raylib.LoadModel(strings.clone_to_cstring(strExtension))

			str, _ := strings.remove(strExtension, ".obj", 1)
			str, _  = strings.remove(str, ".gltf", 1)
			str, _  = strings.remove(str, "data/core/tiles/", 1)
			game.tiles[str] = model
		}
	}

	//* Monster Images
	files := raylib.LoadDirectoryFiles("data/private/sprites/monsters")
	for i:=0;i<int(files.count);i+=1 {
		str := strings.clone_from_cstring(files.paths[i])
		str, _ = strings.remove(str, "data/private/sprites/monsters/", 1)
		str, _ = strings.remove(str, ".png", 1)
		spec, _ := reflect.enum_from_name(game.MonsterSpecies, str)

		game.monsterTextures[spec] = raylib.LoadTexture(files.paths[i])
	}

	//* Monster types
	game.elementalTypes = raylib.LoadTexture("data/private/sprites/spr_types.png")

	//* Bar
	game.barImg = raylib.GenImageColor(200, 1, {173,173,173,255})
}

close :: proc() {
	//* Images
	//* Models
}