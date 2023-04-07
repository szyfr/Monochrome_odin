package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "settings"
import "localization"
import "game/events"
import "game/camera"
import "game/player"
import "game/graphics"
import "debug"


//= Main
logic :: proc() {
	//* Core
	camera.update()
	player.update()
}

draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground({57,57,57,255})
	raylib.EndDrawing()
}

init :: proc() {
	//* Settings / Localization / Graphics
	settings.init()
	localization.init()
	graphics.init()

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
	camera.init()
	player.init()

	//* World
	events.init()
}

close :: proc() {
	//* Localization
	localization.close()

	//* Raylib
	raylib.CloseWindow()

	//* Core
	camera.close()
	player.close()

	//* World
	events.init()
}

main :: proc() {
	init()
	defer close()

	for !raylib.WindowShouldClose() && game.running {
		logic()
		draw()
	}
}