package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "game"
import "graphics/areas"
import "graphics/tiles"
import "graphics/sprites"
import "graphics/sprites/animations"


camera : raylib.Camera3D
sprite : sprites.Sprite

texture : raylib.Texture2D
model   : raylib.Model
modelPly: raylib.Model
meshPly : raylib.Mesh

//= Main
main_logic :: proc() {
	//* Test movement
	//TODO
	mod : raylib.Vector3 = {}
	if raylib.IsKeyPressed(raylib.KeyboardKey.W) do mod.z = -1
	if raylib.IsKeyPressed(raylib.KeyboardKey.S) do mod.z =  1
	if raylib.IsKeyPressed(raylib.KeyboardKey.A) do mod.x = -1
	if raylib.IsKeyPressed(raylib.KeyboardKey.D) do mod.x =  1
	camera.target   += mod
	camera.position += mod

	//* Change camera perspective
	if raylib.IsKeyPressed(raylib.KeyboardKey.P) {
		if camera.projection == .ORTHOGRAPHIC {
			camera.fovy       = 70
			camera.projection = .PERSPECTIVE
		} else {
			camera.fovy       = 10
			camera.projection = .ORTHOGRAPHIC
		}
	}

	//* Turn off map drawing
	if raylib.IsKeyPressed(raylib.KeyboardKey.O) do game.DRAW_MAP = !game.DRAW_MAP
}

main_draw :: proc() {
	raylib.BeginDrawing()
		raylib.ClearBackground(raylib.BLACK)

		//* 3D
		raylib.BeginMode3D(camera)

		//* Draw "player"
		//TODO
		raylib.DrawModelEx(
			modelPly,
			camera.target,
			{0, 1, 0},
			0,
			{1, 1, 1},
			raylib.WHITE,
		)

		//* Draw area
		areas.draw_single_area(camera, areas.areas["New Bark Town"])

		//* Draw sprite
		sprites.draw(camera, &sprite)

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

	//* Load sprite
	texture = raylib.LoadTexture("data/sprTest.png")

	sprite = {
		width    = 16,
		height   = 16,
		position = {0.5, 5, 0.5},
		low      = &texture,
		mid      = nil,
		high     = nil,
		animator = {
			currentAnimation = 0,
			frame = 0,
			timer = 0,
		},
	}

	//* Camera initialization
	camera.position   = {0.5, 7.5, 3}
	camera.target     = {0.5, 0.5, 0.5}
	camera.up         = {0, 1, 0}
	camera.fovy       = 70
	camera.projection = .PERSPECTIVE

	//* Load all tiles
	tiles.init()

	//* Load test map
	areas.init_area("data/mapTest.json")
}

main_close :: proc() {
	//* Close raylib

	//* Unload tiles

	//* Unload areas
}