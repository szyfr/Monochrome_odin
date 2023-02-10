package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "game/entity"
import "game/camera"
import "game/player"
import "game/options"
import "game/localization"
import "game/map/tiles"
import "game/map/zone"

import "debug"


//= Main

main_logic :: proc() {
	//* Camera
	camera.update()

	//* Player
	player.update()
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)

	raylib.BeginMode3D(game.camera)

	//* Zones
	zone.draw_single()

	raylib.EndMode3D()
	raylib.EndDrawing()
}

main_init :: proc() {
	//* Debug
	debug.create_log()

	//* Options / Localization
	options.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.options.screenWidth,
		game.options.screenHeight,
		game.localization["title"],
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(game.options.fpsLimit)
	raylib.SetExitKey(.NULL)

	//* Game
	camera.init()
	player.init()

	//* Map
	tiles.init()
	zone.init() //TODO
}
main_close :: proc() {
	//* Raylib
	raylib.CloseWindow()

	//* Camera
	camera.close()

	//* Player
	player.close()

	//* Tiles
	tiles.close()

	//* Zone
	zone.close()
}

main :: proc() {
	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() && game.running {
		main_logic()
		main_draw()
	}
}