package main


//= Imports
import "core:fmt"

import "vendor:raylib"

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

	camera.position   = {0.5, 7.5, 3}
	camera.target     = {0.5, 0.5, 0.5}
	camera.up         = {0, 1, 0}
	camera.fovy       = 70
	camera.projection = .PERSPECTIVE

	model = raylib.LoadModel("data/Map.obj")
	meshPly  = raylib.GenMeshCube(0.8, 0.8, 0.8)
	modelPly = raylib.LoadModelFromMesh(meshPly)

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

	tiles.init()
	areas.init_area("data/mapTest.json")

	for !raylib.WindowShouldClose() {

		mod : raylib.Vector3 = {}
		if raylib.IsKeyPressed(raylib.KeyboardKey.W) do mod.z = -1
		if raylib.IsKeyPressed(raylib.KeyboardKey.S) do mod.z =  1
		if raylib.IsKeyPressed(raylib.KeyboardKey.A) do mod.x = -1
		if raylib.IsKeyPressed(raylib.KeyboardKey.D) do mod.x =  1

		camera.target   += mod
		camera.position += mod

		if raylib.IsKeyPressed(raylib.KeyboardKey.P) {
			if camera.projection == .ORTHOGRAPHIC {
				camera.fovy       = 70
				camera.projection = .PERSPECTIVE
			} else {
				camera.fovy       = 10
				camera.projection = .ORTHOGRAPHIC
			}
		}
		
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.BLACK)

		raylib.BeginMode3D(camera)

		raylib.DrawGrid(100, 1)
		//DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint);
		
		raylib.DrawModelEx(
			modelPly,
			camera.target,
			{0, 1, 0},
			0,
			{1, 1, 1},
			raylib.WHITE,
		)
		areas.draw(camera)

		sprites.draw(camera, &sprite)

		raylib.EndMode3D()

		raylib.EndDrawing()
	}
}