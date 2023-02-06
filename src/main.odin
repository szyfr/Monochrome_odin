package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "game/entity"
import "game/camera"
import "game/player"
import "game/map/tiles"
import "game/map/zone"


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

	//* Player
	//entity.draw(game.player.entity)

	raylib.EndMode3D()
	raylib.EndDrawing()
}

main_init :: proc() {
	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	//TODO Options
	//TODO Localization
	raylib.InitWindow(
		1280,
		720,
		"Monochrome",
	)
	//TODO Options
	if game.LIMIT_FPS do raylib.SetTargetFPS(85)
	raylib.SetExitKey(.NULL)

	//* Camera
	camera.init()

	//* Player
	player.init()

	//* Tiles
	tiles.init()

	//* Zone
	zone.init()
	fmt.printf("%v\n", game.zones["New Bark Town"].entities)
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

	for !raylib.WindowShouldClose() {
		main_logic()
		main_draw()
	}
}