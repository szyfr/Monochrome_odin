package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "settings"
import "localization"

import "debug"


//= Constants
DEBUG :: true

//= Globals
running : bool : true
tex : raylib.Texture


//= Main
logic :: proc() {}
draw  :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground( {57,57,57,255} )

	//* 3D
	//raylib.BeginMode3D(game.camera)

	//raylib.EndMode3D()

	//* 2D
	//(texture: Texture2D, posX, posY: c.int, tint: Color)
	raylib.DrawTexture(tex, 0,0, raylib.WHITE)

	//* DEBUG
	if DEBUG do debug.update_onscreen(settings.screen_height)

	raylib.EndDrawing()
}

init  :: proc() {
	//* Debug
	debug.onscreenErrors = DEBUG

	//* Settings / Localization
	settings.load()
	localization.load()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		settings.screen_width,
		settings.screen_height,
		localization.text["title"],
	)
	if settings.screen_fps != 0 do raylib.SetTargetFPS(settings.screen_fps)
	raylib.SetExitKey(.KEY_NULL)
}
close :: proc() {
	//* Settings / Localization
	settings.close()
	localization.close()
}

main :: proc() {
	init()
	defer close()

	for !raylib.WindowShouldClose() && running {
		logic()
		draw()
	}
}