package graphics


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
init :: proc() {
	//* Textbox
	//img := raylib.LoadImage("data/core/sprites/ui/textbox.png")
	//raylib.ImageResizeNN(&img, img.width * 4, img.height * 4)
	//game.boxUI = raylib.LoadTextureFromImage(img)
	//raylib.UnloadImage(img)
	
	//* Standee mesh
	game.standeeMesh = raylib.GenMeshPlane(1,1,1,1)
}