package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "graphics/sprites"
import "graphics/sprites/animations"


camera : raylib.Camera3D
sprite : sprites.Sprite

texture : raylib.Texture2D

//= Main
main :: proc() {
	
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		1280,
		720,
		"Monochrome",
	)
	raylib.SetTargetFPS(80)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	texture = raylib.LoadTexture("data/sprTest.png")

	camera.position   = {0, 5, -5}
	camera.target     = {0, 0,  0}
	camera.up         = {0, 1,  0}
	camera.fovy       = 70
	camera.projection = .PERSPECTIVE

	sprite = {
		width    = 16,
		height   = 16,
		position = {0, 0, 0},
		low      = &texture,
		mid      = nil,
		high     = nil,
		animator = {
			currentAnimation = 0,
			frame = 0,
			timer = 0,
		},
	}

	for !raylib.WindowShouldClose() {


		
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)

		raylib.BeginMode3D(camera)

		raylib.DrawGrid(100, 1)

		sprites.draw(camera, &sprite)

		raylib.EndMode3D()

		raylib.EndDrawing()
	}
}