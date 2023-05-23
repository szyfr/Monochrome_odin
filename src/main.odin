package main


//= Imports
import "vendor:raylib"

import "game"
import "game/camera"
import "game/player"
import "game/graphics"
import "game/entity/overworld"

import "settings"
import "localization"

import "debug"


//= Constants
DEBUG :: true


//= Main

logic :: proc() {
	//* Core
	camera.update()
	player.update()
}
draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground( {57,57,57,255} )

	//* 3D
	raylib.BeginMode3D(game.camera)

	overworld.draw(game.player.entity)

	raylib.EndMode3D()

	//* 2D
	//* DEBUG
	if DEBUG do debug.update_onscreen(game.screenHeight)

	raylib.EndDrawing()
}

init :: proc() {
	//* Debug
	debug.onscreenErrors = DEBUG

	//* Settings / Localization
	settings.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.screenWidth,
		game.screenHeight,
		localization.grab_cstring("title"),
	)
	if game.fpsLimit != 0 do raylib.SetTargetFPS(game.fpsLimit)
	raylib.SetExitKey(.KEY_NULL)

	//* Core
	graphics.init()

	camera.init()
	player.init()
}
close :: proc() {
	//* Raylib
	raylib.CloseWindow()
}

main :: proc() {
	init()
	defer close()

	for !raylib.WindowShouldClose() && game.running {
		logic()
		draw()
	}
}