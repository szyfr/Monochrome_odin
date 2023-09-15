package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "settings"
import "localization"
import "camera"
import "player"
import "system"

import "debug"


//= Constants
DEBUG :: true

//= Globals
running : bool : true
testTexture : raylib.Texture


//= Main
logic :: proc() {
	player.update()
	camera.update()
}
draw  :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground( {57,57,57,255} )

	//* 3D
	raylib.BeginMode3D(camera.rl)

	raylib.DrawGrid(100, 1)

	//(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color)
	raylib.DrawBillboardPro(
		camera		= camera.rl,
		texture		= testTexture,
		source		= {0,0,16,16},
		position	= player.unit.position + {0,0.5,0},
		up			= {0.98,0.17,0},
		size		= {1, 1},
		origin		= {1, 2},
		rotation	= 0,
		tint		= raylib.WHITE,
	)
	raylib.DrawBillboardPro(
		camera		= camera.rl,
		texture		= testTexture,
		source		= {0,0,16,16},
		position	= {0,0.5,0},
		up			= {0.98,0.17,0},
		size		= {1, 1},
		origin		= {1, 2},
		rotation	= 0,
		tint		= raylib.WHITE,
	)
	//  0:{ 0.00, -0.17, -0.98}
	// 90:{ 0.98,  0.17,  0.00}
	//180:{ 0.00, -0.17,  0.98}
	//270:{-0.98,  0.17,  0.00}
	fmt.printf("%v\n",system.normalize(system.rotate({0,0.75,-0.75}, camera.rotation)))

	raylib.EndMode3D()

	//* 2D

	//* DEBUG
	if DEBUG do debug.update_onscreen(settings.screen_height)

	raylib.EndDrawing()
}

init  :: proc() {
	//* Debug
	debug.onscreenErrors = DEBUG

	//* Settings / Localization
	settings.load()
	localization.load()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		settings.screen_width,
		settings.screen_height,
		localization.text["title"],
	)
	if settings.screen_fps != 0 do raylib.SetTargetFPS(settings.screen_fps)
	raylib.SetExitKey(.KEY_NULL)

	//* Camera and Player
	camera.init()
	player.init()

	testTexture = raylib.LoadTexture("data/old/sprites/spr_player_1.png")
}
close :: proc() {
	//* Settings / Localization
	settings.close()
	localization.close()
}

main :: proc() {
	init()
	defer close()

	for !raylib.WindowShouldClose() && running {
		logic()
		draw()
	}
}