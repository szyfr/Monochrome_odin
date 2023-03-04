package ui


//= Imports
import "core:fmt"
import "core:strings"
import "core:reflect"

import "vendor:raylib"

import "../../../../game"
import "../../../../game/general/settings"


//= Procedures
draw_menus :: proc() {
	#partial switch game.player.menu {
		case .pause:
			draw_pause_menu()
		case .pokemon:
			draw_pokemon_menu()
	}
}
draw_pause_menu :: proc() {
	posX := f32(game.screenWidth) - (f32(game.screenWidth) / 5)
	raylib.DrawTextureNPatch(
		game.box_ui,
		game.box_ui_npatch,
		{posX, 0, f32(game.screenWidth) / 5, f32(game.screenHeight)},
		{0,0},
		0,
		raylib.WHITE,
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["pokedex"],
		{posX + 100, 60},
		24,
		5,
		//{56,56,56,255},
		{247,82,49,255},
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["pokemon"],
		{posX + 100, 120},
		24,
		5,
		{56,56,56,255},
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["inventory"],
		{posX + 100, 180},
		24,
		5,
		//{56,56,56,255},
		{247,82,49,255},
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["player"],
		{posX + 100, 240},
		24,
		5,
		//{56,56,56,255},
		{247,82,49,255},
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["options"],
		{posX + 100, 300},
		24,
		5,
		{56,56,56,255},
	)

	raylib.DrawTextEx(
		game.font,
		game.localization["quit"],
		{posX + 100, 360},
		24,
		5,
		{56,56,56,255},
	)

	raylib.DrawTexturePro(
		game.pointer,
		{0,0,8,8},
		{posX + 50, 60 + (f32(game.player.menuSel) * 60),32,32},
		{0,8},
		0,
		raylib.WHITE,
	)

	if settings.is_key_pressed("down") {
		game.player.menuSel += 1
		if game.player.menuSel > 5 do game.player.menuSel = 0
	}
	if settings.is_key_pressed("up") {
		game.player.menuSel -= 1
		if game.player.menuSel == 255 do game.player.menuSel = 5
	}
	if settings.is_key_pressed("interact") {
		switch game.player.menuSel {
			case 0: // Pokedex
				//game.player.menu = .pokedex
				//TODO Play error sound
			case 1: // Pokemon
				game.player.menu = .pokemon
			case 2: // Bag
				//game.player.menu = .bag
				//TODO Play error sound
			case 3: // Player
				//game.player.menu = .player
				//TODO Play error sound
			case 4: // Options
				game.player.menu = .options
			case 5: // Quit
				game.running = false
		}
	}
	
}

draw_pokemon_menu :: proc() {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	raylib.DrawTextureNPatch(
		game.box_ui,
		game.box_ui_npatch,
		{posX, posY, f32(game.screenWidth) - (f32(game.screenWidth) / 8), f32(game.screenHeight) - (f32(game.screenHeight) / 8)},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Position 1
	if game.player.pokemon[0].species != .empty {
		//* Sprite
		raylib.DrawTexturePro(
			game.pokemonSprites[game.player.pokemon[0].species],
			{0,0,64,64},
			{posX + 60, posY + 60, 256, 256},
			{0,0},
			0,
			raylib.WHITE,
		)

		offset : f32 = 0
		//* Nickname
		if game.player.pokemon[0].nickname != "" {
			raylib.DrawTextEx(
				game.font,
				game.player.pokemon[0].nickname,
				{posX + 340, posY + 120},
				24,
				5,
				{56,56,56,255},
			)
			offset += 40
		}
		//* Species
		raylib.DrawTextEx(
			game.font,
			game.localization[reflect.enum_string(game.player.pokemon[0].species)],
			{posX + 340, posY + 120 + offset},
			24,
			5,
			{56,56,56,255},
		)
		//* Level
		builder : strings.Builder
		str := fmt.sbprintf(&builder, "%v", game.player.pokemon[0].level)
		raylib.DrawTextEx(
			game.font,
			strings.clone_to_cstring(strings.concatenate({"Lv ", str})),
			{posX + 340, posY + 220},
			24,
			5,
			{56,56,56,255},
		)
		//* Health
		strings.builder_reset(&builder)
		str = fmt.sbprintf(&builder, "%v/%v", game.player.pokemon[0].hpCur, game.player.pokemon[0].hpMax)
		raylib.DrawTextEx(
			game.font,
			strings.clone_to_cstring(str),
			{posX + 188 - (f32(len(str) * 24) / 2), posY + 320},
			24,
			5,
			{56,56,56,255},
		)
	}
}