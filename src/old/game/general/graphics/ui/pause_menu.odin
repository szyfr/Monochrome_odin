package ui


//= Imports
import "core:fmt"
import "core:strings"
import "core:reflect"

import "vendor:raylib"

import "../../../../game"
import "../../../general/settings"
import "../../../general/audio"
import "../../../battle/monsters"


//= Procedures
draw_menus :: proc() {
	#partial switch game.player.menu {
		case .pause:
			draw_pause_menu()
		case .monster:
			draw_monster_menu()
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

	col : raylib.Color

	raylib.DrawTextEx(
		game.font,
		game.localization["pokedex"],
		{posX + 100, 60},
		24,
		5,
		//{56,56,56,255},
		{247,82,49,255},
	)

	col = raylib.Color{56,56,56,255}
	if game.player.monster[0].species == .empty do col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["monster"],
		{posX + 100, 120},
		24,
		5,
		col,
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
			case 1: // Monster
				if game.player.monster[0].species != .empty do game.player.menu = .monster
				//TODO Play error sound
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
		audio.play_sound("button")
	}
	
}

draw_monster_menu :: proc() {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	raylib.DrawTexturePro(
		game.monster_info_ui,
		{0,0,f32(game.monster_info_ui.width),f32(game.monster_info_ui.height)},
		{posX, posY, f32(game.screenWidth) - (f32(game.screenWidth) / 8), f32(game.screenHeight) - (f32(game.screenHeight) / 8) + 0.25},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Position 1
	if game.player.monster[0].species != .empty {
		//* Sprite
		raylib.DrawTexturePro(
			game.monsterSprites[game.player.monster[0].species],
			{0,0,64,64},
			{posX + 76, posY + 76, 256, 256},
			{0,0},
			0,
			raylib.WHITE,
		)

		offset : f32 = 0
		//* Nickname
		if game.player.monster[0].nickname != "" {
			//nick := strings.clone_to_cstring(game.player.monster[0].nickname)
			raylib.DrawTextEx(
				game.font,
				game.player.monster[0].nickname,
				//nick,
				{posX + 380, posY + 95},
				24,
				5,
				{56,56,56,255},
			)
			//delete(nick)
			offset += 40
		}
		//* Species
		raylib.DrawTextEx(
			game.font,
			game.localization[reflect.enum_string(game.player.monster[0].species)],
			{posX + 380, posY + 95 + offset},
			24,
			5,
			{56,56,56,255},
		)

		//* Type
		rect := get_type_rec(game.player.monster[0].elementalType1)
		raylib.DrawTexturePro(
			game.typeTexture,
			rect,
			{posX + 364, posY + 200.25,48*4,8*4},
			{0,0},
			0,
			raylib.WHITE,
		)

		rect = get_type_rec(game.player.monster[1].elementalType1)
		raylib.DrawTexturePro(
			game.typeTexture,
			rect,
			{posX + 556, posY + 200.25,48*4,8*4},
			{0,0},
			0,
			raylib.WHITE,
		)

		//* Level
		builder : strings.Builder
		str := fmt.sbprintf(&builder, "Lv%v", game.player.monster[0].level)
		raylib.DrawTextPro(
			game.font,
			strings.clone_to_cstring(str),
			{posX + 488.5, posY + 340},
			{f32(len(str) * 24) / 2, 12},
			0,
			24,
			5,
			{56,56,56,255},
		)
		//* Bar
		raylib.UnloadTexture(game.barEXP)
		img			:= raylib.ImageCopy(game.barImg)
		raylib.ImageColorReplace(&img, raylib.BLACK, {99,206,8,255})
		ratio		:= monsters.exp_ratio(game.player.monster[0].experience, game.player.monster[0].level)
		game.barEXP	 = raylib.LoadTextureFromImage(img)
		raylib.DrawTexturePro(
			game.barEXP,
			{0,0,f32(img.width) * ratio,f32(img.height)},
			{posX + 364, posY + 364.25,f32(img.width*4) * ratio,f32(img.height*4)},
			{0,0},
			0,
			raylib.WHITE,
		)
		raylib.UnloadImage(img)
		//* Experience
		expNeed := monsters.exp_needed(game.player.monster[0].level) - game.player.monster[0].experience
		strings.builder_reset(&builder)
		str = fmt.sbprintf(&builder, "%v", expNeed)
		raylib.DrawTextPro(
			game.font,
			strings.clone_to_cstring(str),
			{posX + 488.5, posY + 384},
			{f32(len(str) * 24) / 2, 12},
			0,
			24,
			5,
			{56,56,56,255},
		)

		//* Bar
		raylib.UnloadTexture(game.barHP)
		img			= raylib.ImageCopy(game.barImg)
		raylib.ImageColorReplace(&img, raylib.BLACK, {247,82,49,255})
		ratio		= f32(game.player.monster[0].hpCur) / f32(game.player.monster[0].hpMax)
		game.barHP	= raylib.LoadTextureFromImage(img)
		raylib.DrawTexturePro(
			game.barHP,
			{0,0,f32(img.width) * ratio,f32(img.height)},
			{posX + 76, posY + 364.25,f32(img.width*4) * ratio,f32(img.height*4)},
			{0,0},
			0,
			raylib.WHITE,
		)
		raylib.UnloadImage(img)
		//* Health
		strings.builder_reset(&builder)
		str = fmt.sbprintf(&builder, "%v/%v", game.player.monster[0].hpCur, game.player.monster[0].hpMax)
		raylib.DrawTextPro(
			game.font,
			strings.clone_to_cstring(str),
			{posX + 200.5, posY + 384},
			{f32(len(str) * 24) / 2, 12},
			0,
			24,
			5,
			{56,56,56,255},
		)

		//* Stats
		strings.builder_reset(&builder)
		str = fmt.sbprintf(
			&builder,
			"      Stats\nATK:   %v\nDEF:   %v\nSPATK: %v\nSPDEF: %v\nSPD:   %v",
			game.player.monster[0].atk,
			game.player.monster[0].def,
			game.player.monster[0].spAtk,
			game.player.monster[0].spDef,
			game.player.monster[0].spd,
		)
		raylib.DrawTextPro(
			game.font,
			strings.clone_to_cstring(str),
			{posX + 96, posY + 464},
			{0, 0},
			0,
			24,
			5,
			{56,56,56,255},
		)

		//* IVs

		//* EVs
	}
}

get_type_rec :: proc(
	type : game.ElementalType,
) -> raylib.Rectangle {
	#partial switch type {
		case .normal:	return {0,0,48,8}
		case .fire:		return {48,0,48,8}
		case .water:	return {96,0,48,8}
		case .grass:	return {144,0,48,8}
	}
	return {}
}