package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "game/camera"
import "game/over_char"
import "game/player"
import "graphics/areas"
import "graphics/tiles"
import "graphics/sprites"
import "graphics/sprites/animations"


sprite : sprites.Sprite

texture : raylib.Texture2D
model   : raylib.Model
modelPly: raylib.Model
meshPly : raylib.Mesh

//= Main
main_logic :: proc() {
	//* Test movement
	player.update()

	//* Change camera perspective
	//TODO Move to cmaera package
	if raylib.IsKeyPressed(raylib.KeyboardKey.P) {
		if camera.data.projection == .ORTHOGRAPHIC {
			camera.data.fovy       = 70
			camera.data.projection = .PERSPECTIVE
		} else {
			camera.data.fovy       = 10
			camera.data.projection = .ORTHOGRAPHIC
		}
	}

	//* Turn off map drawing
	if raylib.IsKeyPressed(raylib.KeyboardKey.O) do game.DRAW_MAP = !game.DRAW_MAP
}

main_draw :: proc() {
	raylib.BeginDrawing()
		raylib.ClearBackground(raylib.BLACK)

		//* 3D
		raylib.BeginMode3D(camera.data)

		//* Draw area
		areas.draw_single_area(camera.data, areas.areas["New Bark Town"])

		//* Draw "player"
		//TODO Move player drawing to area drawing when player controller is done
		player.draw()

		//* Draw sprite
		

		raylib.EndMode3D()

		//* Draw FPS
		if game.DEBUG do raylib.DrawFPS(10,10)

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
	//* Raylib initialization
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		1280,
		720,
		"Monochrome",
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(80)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	//* Camera init
	camera.init()

	//* Player Init
	player.init()

	//* Load all tiles
	tiles.init()

	//* Load test map
	areas.init_area("data/maps/mapTest.json")
}

main_close :: proc() {
	//* Close raylib

	//* Unload tiles

	//* Unload areas
}