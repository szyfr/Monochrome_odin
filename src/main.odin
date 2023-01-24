package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "game/camera"
import "game/player"
import "game/tiles"
import "game/zone"
import "graphics"


//= Main

main_logic :: proc() {

	//* Player / Camera
	player.update()
	camera.update()

}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.BLACK)
	raylib.BeginMode3D(camera.data)

	//* Zones
	graphics.draw_single()

	//* Player TEMP
	graphics.draw_entity(&player.data.entity)

	raylib.EndMode3D()
	raylib.EndDrawing()
}

main :: proc() {

	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() {
		main_logic()
		main_draw()
	}

}

main_init :: proc() {
	//* Init Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		1280,
		720,
		"Monochrome",
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(80)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	//* Init Player / Camera
	player.init()
	camera.init()

	//* Init Tiles
	tiles.init()

	//* Init Zones
	zone.init()
}

main_close :: proc() {
	//* Close Raylib
	raylib.CloseWindow()
	fmt.printf("Raylib closed\n")

	//* Unload Player / Camera
	player.close()
	camera.close()
	fmt.printf("Player / Camera closed\n")

	//* Unload Tiles
	tiles.close()
	fmt.printf("Tiles closed\n")

	//* Unload Zones
}
