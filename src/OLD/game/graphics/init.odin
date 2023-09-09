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
	load_scalable_graphics()

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

	//* Status Icons
	//game.status = raylib.LoadTexture("data/core/sprites/ui/status.png")
	game.graphicsUI["status_icons"] = raylib.LoadTexture("data/core/sprites/ui/status.png")

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

	//* Monster attacks
	//* Tackle
	img := raylib.LoadImage("data/core/sprites/attacks/tackle.png")
	game.attackTackleTex[0] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {0,0,16,16}))
	game.attackTackleTex[1] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {16,0,16,16}))
	game.attackTackleTex[2] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {32,0,16,16}))
	game.attackTackleMat[0] = raylib.LoadMaterialDefault()
	game.attackTackleMat[1] = raylib.LoadMaterialDefault()
	game.attackTackleMat[2] = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackTackleMat[0], .ALBEDO, game.attackTackleTex[0])
	raylib.SetMaterialTexture(&game.attackTackleMat[1], .ALBEDO, game.attackTackleTex[1])
	raylib.SetMaterialTexture(&game.attackTackleMat[2], .ALBEDO, game.attackTackleTex[2])
	raylib.UnloadImage(img)
	//* Growl
	game.attackGrowlTex = raylib.LoadTexture("data/core/sprites/attacks/growl.png")
	game.attackGrowlMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackGrowlMat, .ALBEDO, game.attackGrowlTex)
	//* Leafage
	game.attackLeafageTex = raylib.LoadTexture("data/core/sprites/attacks/leafage.png")
	game.attackLeafageMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackLeafageMat, .ALBEDO, game.attackLeafageTex)
	//* Scratch
	game.attackScratchTex = raylib.LoadTexture("data/core/sprites/attacks/scratch.png")
	game.attackScratchMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackScratchMat, .ALBEDO, game.attackScratchTex)
	//* Leer
	game.attackLeerTex = raylib.LoadTexture("data/core/sprites/attacks/leer.png")
	game.attackLeerMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackLeerMat, .ALBEDO, game.attackLeerTex)
	//* Ember
	game.attackEmberTex = raylib.LoadTexture("data/core/sprites/attacks/ember.png")
	game.attackEmberMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackEmberMat, .ALBEDO, game.attackEmberTex)
	//* Aqua Jet
	img = raylib.LoadImage("data/core/sprites/attacks/aquajet.png")
	game.attackAquaJetTex[0] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {0,0,16,16}))
	game.attackAquaJetTex[1] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {16,0,16,16}))
	game.attackAquaJetTex[2] = raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {32,0,16,16}))
	game.attackAquaJetMat[0] = raylib.LoadMaterialDefault()
	game.attackAquaJetMat[1] = raylib.LoadMaterialDefault()
	game.attackAquaJetMat[2] = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(&game.attackAquaJetMat[0], .ALBEDO, game.attackAquaJetTex[0])
	raylib.SetMaterialTexture(&game.attackAquaJetMat[1], .ALBEDO, game.attackAquaJetTex[1])
	raylib.SetMaterialTexture(&game.attackAquaJetMat[2], .ALBEDO, game.attackAquaJetTex[2])
	raylib.UnloadImage(img)

	//* Bars
	game.playerBarHP.image = raylib.GenImageColor(200, 1, {173,173,173,255})
	game.playerBarHP.ratio = -20
	game.playerBarST.image = raylib.GenImageColor(200, 1, {173,173,173,255})
	game.playerBarST.ratio = -20
	game.playerBarXP.image = raylib.GenImageColor(200, 1, {173,173,173,255})
	game.playerBarXP.ratio = -20

	game.enemyBarHP.image = raylib.GenImageColor(200, 1, {173,173,173,255})
	game.enemyBarHP.ratio = -20
	game.enemyBarST.image = raylib.GenImageColor(200, 1, {173,173,173,255})
	game.enemyBarST.ratio = -20
	

	//* Targeter
	game.targeter = raylib.LoadImage("data/core/sprites/spr_overlay.png")
	img = raylib.ImageCopy(game.targeter)
	raylib.ImageColorTint(&img, {247,82,49,255})
	game.targeterMat = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(
		&game.targeterMat,
		raylib.MaterialMapIndex.ALBEDO,
		raylib.LoadTextureFromImage(img),
	)
	raylib.UnloadImage(img)

	//* Arrow
	img = raylib.LoadImage("data/core/sprites/arrow.png")
	game.moveArrow[0] = raylib.LoadMaterialDefault()
	game.moveArrow[1] = raylib.LoadMaterialDefault()
	game.moveArrow[2] = raylib.LoadMaterialDefault()
	game.moveArrow[3] = raylib.LoadMaterialDefault()
	raylib.SetMaterialTexture(
		&game.moveArrow[0],
		raylib.MaterialMapIndex.ALBEDO,
		raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {0,0,16,16})),
	)
	raylib.SetMaterialTexture(
		&game.moveArrow[1],
		raylib.MaterialMapIndex.ALBEDO,
		raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {16,0,16,16})),
	)
	raylib.SetMaterialTexture(
		&game.moveArrow[2],
		raylib.MaterialMapIndex.ALBEDO,
		raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {32,0,16,16})),
	)
	raylib.SetMaterialTexture(
		&game.moveArrow[3],
		raylib.MaterialMapIndex.ALBEDO,
		raylib.LoadTextureFromImage(raylib.ImageFromImage(img, {48,0,16,16})),
	)
	raylib.UnloadImage(img)
}

load_scalable_graphics :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	scale := 4 * screenRatio

	//* Textbox
	img := raylib.LoadImage("data/core/sprites/ui/textbox.png")
	raylib.ImageResizeNN(&img, img.width * i32(scale), img.height * i32(scale))
	game.boxUI = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	//* Statusbox
	img = raylib.LoadImage("data/core/sprites/ui/statusbox.png")
	raylib.ImageResizeNN(&img, img.width * i32(scale), img.height * i32(scale))
	game.statusboxUI = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	size := game.boxUI.width / 3
	game.boxUI_npatch = {
		{ 0, 0, f32(game.boxUI.width), f32(game.boxUI.height)},
		size,size,size,size,
		.NINE_PATCH,
	}
	
	game.graphicsUI["textbox_general"]		= raylib.LoadTexture("data/core/sprites/ui/textbox.png")
	game.graphicsNPatch["textbox_general"]	= {
		{ 0, 0, f32(game.graphicsUI["textbox_general"].width), f32(game.graphicsUI["textbox_general"].width) },
		game.graphicsUI["textbox_general"].width/3, game.graphicsUI["textbox_general"].width/3,
		game.graphicsUI["textbox_general"].width/3, game.graphicsUI["textbox_general"].width/3,
		.NINE_PATCH,
	}
	game.graphicsUI["textbox_player_status"]		= raylib.LoadTexture("data/core/sprites/ui/statusbox.png")
	game.graphicsNPatch["textbox_player_status"]	= game.graphicsNPatch["textbox_general"]
}

close :: proc() {
	//* Images
	//* Models
}