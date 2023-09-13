package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "settings"
import "localization"
import "camera"
import "player"

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

	raylib.DrawBillboardRec(camera.rl, testTexture, {0,0,16,16}, player.unit.position + {0,1,0}, {1,2}, raylib.WHITE)

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