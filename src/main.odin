package main


//= Imports
import "vendor:raylib"

import "game"
import "game/camera"
import "game/player"
import "game/graphics"
import "game/graphics/ui"
import "game/audio"
import "game/region"
import "game/events"
import "game/monsters"
import "game/battle"
import "game/entity/overworld"
import "game/entity/emotes"

import "settings"
import "localization"

import "debug"


//= Constants
DEBUG :: true


//= Main

logic :: proc() {
	//* Core
	camera.update()
	player.update()

	region.update()
	raylib.UpdateMusicStream(game.audio.musicCurrent)

	battle.update()

	if settings.is_key_pressed("pause") && game.battleData != nil do battle.close()
}
draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground( {57,57,57,255} )

	//* 3D
	raylib.BeginMode3D(game.camera)

	region.draw()
	emotes.draw()

	if game.battleData != nil do battle.draw()

	raylib.EndMode3D()

	//* 2D
	ui.draw_pause_menus()
	ui.draw_textbox()
	if game.overlayActive {
		raylib.DrawTexturePro(
			game.overlayTexture,
			game.overlayRectangle,
			{0,0,f32(game.screenWidth),f32(game.screenHeight)},
			{0,0},
			0,
			raylib.WHITE,
		)
	}
	//* DEBUG
	if DEBUG do debug.update_onscreen(game.screenHeight)

	raylib.EndDrawing()
}

init :: proc() {
	//* Debug
	debug.onscreenErrors = DEBUG

	//* Settings / Localization
	settings.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.screenWidth,
		game.screenHeight,
		localization.grab_cstring("title"),
	)
	if game.fpsLimit != 0 do raylib.SetTargetFPS(game.fpsLimit)
	raylib.SetExitKey(.KEY_NULL)

	//* Core
	graphics.init()
	audio.init()
	audio.play_music("new_bark_town") // TODO: TEMP
	events.init()
	region.init("data/core/regions/region1/")

	camera.init()
	player.init()
}
close :: proc() {
	//* Localization
	localization.close()

	//* Core
	graphics.close()

	camera.close()
	player.close()

	//* Raylib
	raylib.CloseWindow()
}

main :: proc() {
	init()
	defer close()

	for !raylib.WindowShouldClose() && game.running {
		logic()
		draw()
	}
}