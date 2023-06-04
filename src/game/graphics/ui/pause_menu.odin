package ui


//= Imports
import "core:reflect"
import "core:strings"
import "core:fmt"

import "vendor:raylib"

import "../../../game"
import "../../audio"
import "../../../settings"


//= Procedures
draw_pause_menus :: proc() {
	#partial switch game.player.menu {
		case .pause:	draw_pause()
		case .monster:	draw_monster()
	}
}

draw_pause :: proc() {
	screenWidth_2	:= (f32(game.screenWidth) / 2)
	screenWidth_3	:= (f32(game.screenWidth) / 3)
	screenWidth_4	:= (f32(game.screenWidth) / 4)
	screenWidth_5	:= (f32(game.screenWidth) / 5)
	screenHeight_4	:= (f32(game.screenHeight) / 4)
	screenRatio		:= (f32(game.screenHeight) / 720)
	posX := f32(game.screenWidth) - screenWidth_5

	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX, 0, screenWidth_5, f32(game.screenHeight)},
		{0,0},
		0,
		raylib.WHITE,
	)

	col : raylib.Color
	//* Wiki
	variable, result := game.eventmanager.eventVariables["hasWiki"]
	if result && variable.(bool)	do col = {56,56,56,255}
	else							do col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["wiki"],
		{posX + 100, 60},
		16 * screenRatio,
		5,
		col,
	)
	//* Monsters
	col = raylib.Color{56,56,56,255}
	if game.player.monsters[0].species != .empty do col = {56,56,56,255}
	else										do col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["monster"],
		{posX + 100, 120},
		16 * screenRatio,
		5,
		col,
	)
	//* Inventory
	variable, result = game.eventmanager.eventVariables["hasInventory"]
	if result && variable.(bool)	do col = {56,56,56,255}
	else							do col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["inventory"],
		{posX + 100, 180},
		16 * screenRatio,
		5,
		col,
	)
	//* Player
	variable, result = game.eventmanager.eventVariables["hasLeagueCard"]
	if result && variable.(bool)	do col = {56,56,56,255}
	else							do col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["player"],
		{posX + 100, 240},
		16 * screenRatio,
		5,
		col,
	)
	//* Save
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["save"],
		{posX + 100, 300},
		16 * screenRatio,
		5,
		col,
	)
	//* Load
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["load"],
		{posX + 100, 360},
		16 * screenRatio,
		5,
		col,
	)
	//* Quick Reload
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["quickload"],
		{posX + 100, 420},
		16 * screenRatio,
		5,
		col,
	)
	//* Options
	col = {56,56,56,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["options"],
		{posX + 100, 480},
		16 * screenRatio,
		5,
		col,
	)
	//* Quit
	col = {56,56,56,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["quit"],
		{posX + 100, 540},
		16 * screenRatio,
		5,
		col,
	)

	//* Cursor
	raylib.DrawTexturePro(
		game.pointer,
		{0,0,8,8},
		{posX + 50, 60 + (f32(game.player.menuSel) * 60),32,32},
		{0,8},
		0,
		raylib.WHITE,
	)

	//* Controls
	if settings.is_key_pressed("down") {
		game.player.menuSel += 1
		if game.player.menuSel > 8 do game.player.menuSel = 0
	}
	if settings.is_key_pressed("up") {
		game.player.menuSel -= 1
		if game.player.menuSel == 255 do game.player.menuSel = 8
	}
	
	//* Interaction
	if settings.is_key_pressed("interact") {
		switch game.player.menuSel {
			case 0: // Pokedex
				//game.player.menu = .pokedex
				//TODO Play error sound
			case 1: // Monster
				if game.player.monsters[0].species != .empty {
					game.player.menu = .monster
					audio.play_sound("button")
				}
				//TODO Play error sound
			case 2: // Bag
				//game.player.menu = .bag
				//TODO Play error sound
			case 3: // Player
				//game.player.menu = .player
				//TODO Play error sound
			case 4: // Save
				//game.player.menu = .save
				//TODO Play error sound
			case 5: // Load
				//game.player.menu = .load
				//TODO Play error sound
			case 6: // Reload
				//game.player.menu = .load
				//TODO Play error sound
			case 7: // Options
				game.player.menu = .options
				audio.play_sound("button")
			case 8: // Quit
				game.running = false
				audio.play_sound("button")
		}
	}
}

draw_monster :: proc() {
	screenWidth_2	:= (f32(game.screenWidth) / 2)
	screenWidth_3	:= (f32(game.screenWidth) / 3)
	screenWidth_4	:= (f32(game.screenWidth) / 4)
	screenWidth_5	:= (f32(game.screenWidth) / 5)
	screenWidth_8	:= (f32(game.screenWidth) / 8)
	screenHeight_4	:= (f32(game.screenHeight) / 4)
	screenHeight_8	:= (f32(game.screenHeight) / 8)
	screenRatio		:= (f32(game.screenHeight) / 720)
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16

	raylib.DrawTexturePro(
		game.monsterBox,
		{0,0,f32(game.monsterBox.width),f32(game.monsterBox.height)},
		{posX, posY, f32(game.screenWidth) - screenWidth_8, f32(game.screenHeight) - screenHeight_8 + 0.25},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Position 1
	
	//* Sprite
	name := reflect.enum_string(game.player.monsters[0].species)
	raylib.DrawTexturePro(
		game.monsterTextures[name],
		{0,0,64,64},
		{posX + 76, posY + 76, 256, 256},
		{0,0},
		0,
		raylib.WHITE,
	)
	offset : f32 = 0
	//* Nickname
	if game.player.monsters[0].nickname != "" {
		raylib.DrawTextEx(
			game.font,
			game.player.monsters[0].nickname,
			{posX + 380, posY + 95},
			24,
			5,
			{56,56,56,255},
		)
		offset += 40
	}
	//* Species
	raylib.DrawTextEx(
		game.font,
		game.localization[reflect.enum_string(game.player.monsters[0].species)],
		{posX + 380, posY + 95 + offset},
		24,
		5,
		{56,56,56,255},
	)
}