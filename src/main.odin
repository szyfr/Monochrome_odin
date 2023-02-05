package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "game/entity"
import "game/camera"
import "game/player"


//= Main

main_logic :: proc() {
	//* Camera
	camera.update()

	//* Player
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)

	raylib.BeginMode3D(game.camera)

	//* Player
	entity.draw(game.player.entity)

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
}
main_close :: proc() {
	//* Raylib
	raylib.CloseWindow()

	//* Camera
	camera.close()

	//* Player
	player.close()
}

main :: proc() {
	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() {
		main_logic()
		main_draw()
	}
}