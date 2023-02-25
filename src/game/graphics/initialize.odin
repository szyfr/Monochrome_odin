package graphics


//= Imports
import "vendor:raylib"

import "../../game"


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

	game.emotes	= raylib.LoadTexture("data/sprites/spr_emotes.png")
	trgTex	:= raylib.LoadTexture("data/sprites/spr_targeter.png")
	mesh	:= raylib.GenMeshPlane(1,1,1,1)
	game.targeter = raylib.LoadModelFromMesh(mesh)
	game.targeter.materials[0].maps[0].texture = trgTex

	game.font = raylib.LoadFont("data/sprites/ui/font.ttf")
}
close :: proc() {
	raylib.UnloadTexture(game.box_ui)
	raylib.UnloadFont(game.font)
}