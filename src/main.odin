package main


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "settings"
import "localization"
import "graphics"
import "camera"
import "player"
import "world"
import "system"

import "debug"


//= Constants
DEBUG :: true


//= Globals
running : bool : true


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

	//raylib.DrawGrid(100, 1)

	world.draw()

	//(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color)
	raylib.DrawBillboardPro(
		camera		= camera.rl,
		texture		= graphics.textures["overworld_player"],
		source		= {0,0,16,16},
		position	= player.unit.position,
		up			= {math.sin(camera.rotation / 57.3), 1, -math.cos(camera.rotation / 57.3)},
		size		= {1, 0.75},
		origin		= {0, 0},
		rotation	= 0,
		tint		= raylib.WHITE,
	)
	//  0:{ 0.00, -0.17, -0.98}
	// 90:{ 0.98,  0.17,  0.00}
	//180:{ 0.00, -0.17,  0.98}
	//270:{-0.98,  0.17,  0.00}

	raylib.EndMode3D()

	//* 2D
	raylib.DrawFPS(0,0)

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
	//raylib.rlDisableBackfaceCulling()

	//* Camera and Player
	camera.init()
	player.init()

	//* Graphics
	graphics.init_textures()
	world.init_tiles()

	//! TEMP
	world.init_map("data/world/test.json")
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