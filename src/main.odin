package main


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "game"

import "game/general/camera"
import "game/general/settings"
import "game/general/localization"
import "game/general/graphics"
import "game/general/graphics/ui"
import "game/general/graphics/ui/textbox"

import "game/overworld/map/tiles"
import "game/overworld/map/region"
import "game/overworld/entity"
import "game/overworld/player"
import "game/overworld/events"

import "game/battle"
import "game/battle/monsters"

import "debug"


//= Main

main_logic :: proc() {
	//* Overworld
	camera.update()
	player.update()
	region.update()
	if game.battleStruct != nil do battle.update()

	if settings.is_key_pressed("debug") {
		//for pkmn in game.player.pokemon do fmt.printf("%v\n",pkmn)
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
		game.screenWidth,
		game.screenHeight,
		game.localization["title"],
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(game.fpsLimit)
	raylib.SetExitKey(.NULL)
	raylib.InitAudioDevice()
	raylib.SetMasterVolume(game.masterVolume)

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

	game.currentTrack = "new_bark_town"
	game.music["new_bark_town"]		= raylib.LoadSound("data/audio/aud_new_bark_town.wav")
	game.music["trainer_battle"]	= raylib.LoadSound("data/audio/aud_trainer_battle.wav")
	raylib.PlaySound(game.music[game.currentTrack])
}
main_close :: proc() {
	//* Raylib
	raylib.CloseWindow()
	raylib.CloseAudioDevice()

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