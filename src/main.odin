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
import "game/general/audio"

import "game/overworld/map/tiles"
import "game/overworld/map/region"
import "game/overworld/emotes"
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

	raylib.UpdateMusicStream(game.audio.musicCurrent)

	if settings.is_key_pressed("debug") {
		for i in game.region.events {
			monsters.add_to_team(monsters.create(.chikorita, 5))
			battle.init(&game.battles["rival_battle_cyndaquil"])
		}
	}
}

main_draw :: proc() {
	raylib.BeginDrawing()
	raylib.ClearBackground({57,57,57,255})
	raylib.BeginMode3D(game.camera)

	//* Region
	region.draw()
	if game.battleStruct != nil do battle.draw()
	emotes.draw()

	raylib.EndMode3D()

	ui.draw_menus()
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
	if game.levelUpDisplay != nil {
		posX := f32(game.screenWidth) / 4
		posY := f32(game.screenHeight) - (f32(game.screenHeight) / 2)
		raylib.DrawTextureNPatch(
			game.box_ui,
			game.box_ui_npatch,
			{
				posX + (f32(game.screenWidth) / 6),
				posY - (f32(game.screenHeight) / 4),
				(f32(game.screenWidth) / 2) - (f32(game.screenWidth) / 6),
				f32(game.screenHeight) / 2},
			{0,0},
			0,
			raylib.WHITE,
		)
		builder : strings.Builder
		str := fmt.sbprintf(
			&builder,
			" Level %v-%v\n\nHP:    %v-%v\nAtk:   %v-%v\nDef:   %v-%v\nSpAtk: %v-%v\nSpDef: %v-%v\nSpd:   %v-%v",
			game.levelUpDisplay.level, game.player.monster[0].level,
			game.levelUpDisplay.hp, game.player.monster[0].hpMax,
			game.levelUpDisplay.atk, game.player.monster[0].atk,
			game.levelUpDisplay.def, game.player.monster[0].def,
			game.levelUpDisplay.spatk, game.player.monster[0].spAtk,
			game.levelUpDisplay.spdef, game.player.monster[0].spDef,
			game.levelUpDisplay.spd, game.player.monster[0].spd,
		)
		cstr := strings.clone_to_cstring(str)
		raylib.DrawTextEx(
			game.font,
			cstr,
			{
				posX + (f32(game.screenWidth) / 6) + 60,
				posY - (f32(game.screenHeight) / 4) + 90,
			},
			32,
			5,
			{56,56,56,255},
		)
		delete(cstr)
	}

	if game.battleStruct != nil do ui.draw_battle()

	builder : strings.Builder
	last : raylib.Vector3 = {}
	if game.battleStruct != nil do last = game.battleStruct.playerMonster.position
	cstr := strings.clone_to_cstring(fmt.sbprintf(
		&builder,
		"Previous: %v\nCurrent: %v\nTarget: %v\n\nMonster:%v\n",
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

	//* Settings / Save / Localization
	settings.init()
	localization.init()
	events.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.screenWidth,
		game.screenHeight,
		game.localization["title"],
	)
	if game.LIMIT_FPS do raylib.SetTargetFPS(game.fpsLimit)
	raylib.SetExitKey(.NULL)

	//* Data
	camera.init()
	player.init()
	monsters.init()
	tiles.init()
	region.init("data/maps/regionTest.json")

	//* Graphics
	graphics.init()

	//* Audio
	audio.init()
	audio.play_music("new_bark_town")
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

	//* Audio
	audio.close()
}

main :: proc() {
	main_init()
	defer main_close()

	for !raylib.WindowShouldClose() && game.running {
		main_logic()
		main_draw()
	}
}