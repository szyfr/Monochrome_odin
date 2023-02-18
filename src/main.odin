package main


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "game"
import "game/entity"
import "game/camera"
import "game/player"
import "game/options"
import "game/localization"
import "game/graphics"
import "game/textbox"
import "game/events"
import "game/map/tiles"
import "game/map/region"

import "debug"


//= Main

main_logic :: proc() {
	//* Overworld
	camera.update()
	player.update()
	events.update()

	if raylib.IsKeyPressed(.O) {
		for ev in game.region.events do fmt.printf("%v\n", ev)
	}
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)
	raylib.BeginMode3D(game.camera)

	//* Region
	region.draw()

	raylib.EndMode3D()

	textbox.draw()

	builder : strings.Builder
	cstr := strings.clone_to_cstring(fmt.sbprintf(&builder, "Previous: %v\nCurrent: %v\nTarget: %v\n\n", game.player.entity.previous, game.player.entity.position, game.player.entity.target))
	raylib.DrawText(
		cstr,
		10, 10,
		20,
		raylib.BLACK,
	)
	delete(cstr)
	strings.builder_destroy(&builder)
	raylib.EndDrawing()
}

main_init :: proc() {
	//* Debug
	debug.create_log()

	//* Options / Localization
	options.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.options.screenWidth,
		game.options.screenHeight,
		game.localization["title"],
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(game.options.fpsLimit)
	raylib.SetExitKey(.NULL)

	//* Game
	camera.init()
	player.init()

	//* Map
	tiles.init()
	region.init("data/maps/regionTest.json")

	//* Graphics
	graphics.init()

	//* Temp
	game.eventmanager = new(game.EventManager)
}
main_close :: proc() {
	//* Raylib
	raylib.CloseWindow()

	//* Overworld
	camera.close()
	player.close()

	//* Map
	tiles.close()
	region.close()

	//* Graphics
	graphics.close()
}

main :: proc() {
	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() && game.running {
		main_logic()
		main_draw()
	}
}