package main


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "game"
import "game/entity"
import "game/camera"
import "game/player"
import "game/settings"
import "game/localization"
import "game/graphics"
import "game/events"
import "game/battle"
import "game/monsters"
import "game/map/tiles"
import "game/map/region"
import "game/ui"
import "game/ui/textbox"

import "debug"


//= Main

main_logic :: proc() {
	//* Overworld
	camera.update()
	player.update()
	region.update()
	if game.battleStruct != nil do battle.update()

	if settings.is_key_pressed("debug") {
		for pkmn in game.player.pokemon do fmt.printf("%v\n",pkmn)
	}
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground({57,57,57,255})
	raylib.BeginMode3D(game.camera)

	//* Region
	region.draw()
	if game.battleStruct != nil do battle.draw()

	raylib.EndMode3D()

	entity.draw_emotes()
	textbox.draw()

	if game.battleStruct != nil do ui.draw_battle()

	builder : strings.Builder
	last : raylib.Vector3 = {}
	if game.battleStruct != nil do last = game.battleStruct.playerPokemon.position
	cstr := strings.clone_to_cstring(fmt.sbprintf(
		&builder,
		"Previous: %v\nCurrent: %v\nTarget: %v\n\nPokemon:%v\n",
		game.player.entity.previous,
		game.player.entity.position,
		game.player.entity.target,
		last,
	))
	raylib.DrawText(
		cstr,
		10, 430,
		20,
		raylib.BLACK,
	)
	delete(cstr)
	strings.builder_destroy(&builder)
	raylib.DrawFPS(10,400)

	raylib.EndDrawing()
}

main_init :: proc() {
	//* Debug
	debug.create_log()

	//* Settings / Localization
	settings.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.settings.screenWidth,
		game.settings.screenHeight,
		game.localization["title"],
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(game.settings.fpsLimit)
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
	game.eventmanager.eventVariables["variable_1"] = false
	game.eventmanager.eventVariables["rival_battle_1"] = false
	game.player.pokemon[0] = monsters.create(.chikorita, 5)
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