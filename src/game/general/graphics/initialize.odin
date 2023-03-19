package graphics


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:reflect"
import "core:encoding/json"

import "vendor:raylib"

import "../../../game"


//= Procedures
init :: proc() {
	img := raylib.LoadImage("data/sprites/ui/textbox.png")
	raylib.ImageResizeNN(&img, img.width * 4, img.height * 4)
	game.box_ui = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	size := game.box_ui.width / 3
	game.box_ui_npatch = {
		{ 0, 0, f32(game.box_ui.width), f32(game.box_ui.height)},
		size,size,size,size,
		.NINE_PATCH,
	}

	img = raylib.LoadImage("data/sprites/ui/spr_pokemon_info.png")
	raylib.ImageResizeNN(&img, img.width * 4, img.height * 4)
	game.pokemon_info_ui = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)

	game.pointer = raylib.LoadTexture("data/sprites/ui/spr_pointer.png")

	game.typeTexture = raylib.LoadTexture("data/sprites/ui/spr_types.png")

	game.barImg = raylib.LoadImage("data/sprites/ui/spr_bar.png")

	for pk in game.PokemonSpecies {
		str := reflect.enum_string(pk)
		game.pokemonSprites[pk] = raylib.LoadTexture(strings.clone_to_cstring(strings.concatenate({"data/sprites/pokemon/pk_",str,".png"})))
	}

	count : i32 = 0
	directories := raylib.GetDirectoryFiles("data/attacks", &count)
	for i:=2;i<int(count);i+=1 {
		strLoc := strings.clone_from_cstring(directories[i])
		result := strings.contains(strLoc,".obj")
		if !result do continue
		strName, _ := strings.remove_all(strLoc,".obj")
		strName, _ = strings.remove_all(strName,"atk_")
		game.attackModels[strName] = raylib.LoadModel(strings.clone_to_cstring(strings.concatenate({"data/attacks/",strLoc})))
	}

	game.emotes	= raylib.LoadTexture("data/sprites/spr_emotes.png")

	trgTex	:= raylib.LoadTexture("data/sprites/spr_targeter.png")
	mesh	:= raylib.GenMeshPlane(1,1,1,1)
	game.targeter = raylib.LoadModelFromMesh(mesh)
	game.targeter.materials[0].maps[0].texture = trgTex

	game.font = raylib.LoadFont("data/sprites/ui/font.ttf")

	fileRaw, rawRes		:= os.read_entire_file("data/sprites/overlays/overlays.json")
	fileJson, jsonRaw	:= json.parse(fileRaw)
	//TODO Error check
	for i in fileJson.(json.Object)["overlays"].(json.Array) {
		overlay : game.AttackOverlayGeneral = {}

		switch i.(json.Array)[0].(string) {
			case "general":
				str := strings.concatenate({"data/sprites/overlays/spr_", i.(json.Array)[1].(string), ".png"})
				overlay.texture	= raylib.LoadTexture(strings.clone_to_cstring(str))
				overlay.mesh	= raylib.GenMeshPlane(f32(overlay.texture.width) / 16, f32(overlay.texture.height) / 16, 1, 1)
				count := overlay.mesh.vertexCount
				for i in 0..<count {
					overlay.mesh.vertices[(i*3)]	-= 0.5
					overlay.mesh.vertices[(i*3)+2]	-= 0.5
				}
				overlay.model	= raylib.LoadModelFromMesh(overlay.mesh)
				overlay.model.materials[0].maps[0].texture = overlay.texture

				overlay.model.transform[3,0] = f32(i.(json.Array)[2].(json.Array)[0].(f64))
				overlay.model.transform[3,1] = f32(i.(json.Array)[2].(json.Array)[1].(f64))
				overlay.model.transform[3,2] = f32(i.(json.Array)[2].(json.Array)[2].(f64))
		}

		atk, _ := reflect.enum_from_name(game.PokemonAttack, i.(json.Array)[1].(string))
		game.attackOverlays[atk] = overlay
	}
}
close :: proc() {
	raylib.UnloadTexture(game.box_ui)
	raylib.UnloadFont(game.font)
}