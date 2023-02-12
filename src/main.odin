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
import "game/map/region"

import "debug"


//= Main

main_logic :: proc() {
	//* Overworld
	camera.update()
	player.update()
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)

	raylib.BeginMode3D(game.camera)

	//* Zones
	zone.draw_single()
	region.draw()

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
	region.init("data/maps/regionTest.json")
	//fmt.printf("%v\n",game.region)
	//zone.init() //TODO
}
main_close :: proc() {
	//* Raylib
	raylib.CloseWindow()

	//* Overworld
	camera.close()
	player.close()

	//* Map
	tiles.close()
	//zone.close()
}

main :: proc() {
	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() && game.running {
		main_logic()
		main_draw()
	}
}