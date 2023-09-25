package main


//= Imports
import "core:fmt"
import "core:math"

import "vendor:raylib"

import "data"
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
	using data

	raylib.BeginDrawing()
	raylib.ClearBackground( {57,57,57,255} )

	//* 3D
	raylib.BeginMode3D(cameraData.rl)

	world.draw()

	//texture := graphics.textures["overworld_player"]
	//position := playerData.unit.position + {0,0.5,0}
	//raylib.DrawBillboardPro(
	//	camera		= cameraData.rl,
	//	texture		= texture,
	//	source		= {0,0,16,16},
	//	position	= position,
	//	up			= {math.sin(cameraData.rotation / 57.3), 1, -math.cos(cameraData.rotation / 57.3)},
	//	size		= {1, 0.75},
	//	origin		= {0, 0},
	//	rotation	= 0,
	//	tint		= raylib.WHITE,
	//)

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

	//* Graphics
	fmt.printf("Fuck\n")
	graphics.init_textures()
	fmt.printf("Fuck\n")
	world.init_tiles()
	fmt.printf("Fuck\n")

	//* Camera and Player
	camera.init()
	player.init()

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