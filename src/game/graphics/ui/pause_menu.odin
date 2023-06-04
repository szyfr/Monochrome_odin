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
	screenWidth_4	:= (f32(game.screenWidth) / 4)
	screenRatio		:= (f32(game.screenHeight) / 720)
	posX := f32(game.screenWidth) - screenWidth_4
	offset := (40 * screenRatio)

	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX, 0, screenWidth_4, f32(game.screenHeight)},
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
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 0)},
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
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 1)},
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
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 2)},
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
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 3)},
		16 * screenRatio,
		5,
		col,
	)
	//* Save
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["save"],
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 4)},
		16 * screenRatio,
		5,
		col,
	)
	//* Load
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["load"],
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 5)},
		16 * screenRatio,
		5,
		col,
	)
	//* Quick Reload
	col = {247,82,49,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["quickload"],
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 6)},
		16 * screenRatio,
		5,
		col,
	)
	//* Options
	col = {56,56,56,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["options"],
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 7)},
		16 * screenRatio,
		5,
		col,
	)
	//* Quit
	col = {56,56,56,255}
	raylib.DrawTextEx(
		game.font,
		game.localization["quit"],
		{posX + (100 * screenRatio), (60 * screenRatio) + (offset * 8)},
		16 * screenRatio,
		5,
		col,
	)

	//* Cursor
	raylib.DrawTexturePro(
		game.pointer,
		{0,0,8,8},
		{posX + (50 * screenRatio), (60 * screenRatio) + (f32(game.player.menuSel) * offset),24 * screenRatio,24 * screenRatio},
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
	screenHeight_5	:= (f32(game.screenHeight) / 5)
	screenHeight_6	:= (f32(game.screenHeight) / 6)
	screenHeight_8	:= (f32(game.screenHeight) / 8)
	screenRatio		:= (f32(game.screenHeight) / 720)
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16

	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX, posY, f32(game.screenWidth) - screenWidth_8, f32(game.screenHeight) - screenHeight_8},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Position 1
	//* Sprite
	raylib.DrawTexturePro(
		game.monsterTextures[game.player.monsters[0].species],
		{0,0,64,64},
		{posX + (55 * screenRatio), posY + (60 * screenRatio), (192 * screenRatio), (192 * screenRatio)},
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
			{posX + (280 * screenRatio), posY + (80 * screenRatio)},
			16 * screenRatio,
			5,
			{56,56,56,255},
		)
		offset += (32 * screenRatio)
	}
	//* Species
	raylib.DrawTextEx(
		game.font,
		game.localization[reflect.enum_string(game.player.monsters[0].species)],
		{posX + (280 * screenRatio), posY + (80 * screenRatio) + offset},
		16 * screenRatio,
		5,
		{56,56,56,255},
	)
	//* Types
	rect : raylib.Rectangle = {48 * (f32(game.player.monsters[0].elementalType1)-1),0,48,8}
	raylib.DrawTexturePro(
		game.elementalTypes,
		rect,
		{posX + (280 * screenRatio), posY + (160 * screenRatio),(128 * screenRatio),(21.333333 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
	rect = {48 * (f32(game.player.monsters[0].elementalType2)-1),0,48,8}
	raylib.DrawTexturePro(
		game.elementalTypes,
		rect,
		{posX + (408 * screenRatio), posY + (160 * screenRatio),(128 * screenRatio),(21.333333 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
	//* Level
	builder : strings.Builder
	str := fmt.sbprintf(&builder, "Lv%v", game.player.monsters[0].level)
	cstr := strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (404 * screenRatio), posY + (214 * screenRatio)},
		{(f32(len(str)) * (16 * screenRatio)) / 2, 12},
		0,
		16 * screenRatio,
		5,
		{56,56,56,255},
	)
	//* Exp Bar
	raylib.UnloadTexture(game.barExp)
	img := raylib.ImageCopy(game.barImg)
	raylib.ImageColorReplace(&img, raylib.BLACK, raylib.WHITE)
	ratio : f32 = 0.75//monsters.exp_ratio(game.player.monsters[0].experience, game.player.monsters[0].level)
	for i:=0;i<int(ratio * 200);i+=1 {
		raylib.ImageDrawPixel(&img, i32(i), 0, {99,206,8,255})
	}
	game.barExp	 = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.barExp,
		{0,0,f32(img.width),f32(img.height)},
		{posX + (280 * screenRatio), posY + (224 * screenRatio),(256 * screenRatio),(16 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
	//* Experience
	expNeed := 100 //monsters.exp_needed(game.player.monsters[0].level) - game.player.monsters[0].experience
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v", expNeed)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (404 * screenRatio), posY + (226 * screenRatio)},
		{(f32(len(str)) * (16 * screenRatio)) / 2, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Hp Text
	raylib.DrawTextPro(
		game.font,
		game.localization["hp"],
		{posX + (130 * screenRatio), posY + (286 * screenRatio)},
		{((3 * 1.25) * (16 * screenRatio)) / 2, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
	//* Hp Bar
	raylib.UnloadTexture(game.barHp)
	img = raylib.ImageCopy(game.barImg)
	raylib.ImageColorReplace(&img, raylib.BLACK, raylib.WHITE)
	ratio = f32(game.player.monsters[0].hpCur) / f32(game.player.monsters[0].hpMax)
	for i:=0;i<int(ratio * 200);i+=1 {
		raylib.ImageDrawPixel(&img, i32(i), 0, {247,82,49,255})
	}
	game.barHp	 = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.barHp,
		{0,0,f32(img.width),f32(img.height)},
		{posX + (160 * screenRatio), posY + (284 * screenRatio),(256 * screenRatio),(16 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
	//* Health
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v/%v", game.player.monsters[0].hpCur, game.player.monsters[0].hpMax)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (288 * screenRatio), posY + (286 * screenRatio)},
		{((f32(len(str)) * 1.25) * (16 * screenRatio)) / 2, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* St Text
	raylib.DrawTextPro(
		game.font,
		game.localization["st"],
		{posX + (130 * screenRatio), posY + (311 * screenRatio)},
		{((3 * 1.25) * (16 * screenRatio)) / 2, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
	//* St Bar
	raylib.UnloadTexture(game.barSt)
	img = raylib.ImageCopy(game.barImg)
	raylib.ImageColorReplace(&img, raylib.BLACK, raylib.WHITE)
	ratio = f32(game.player.monsters[0].stCur) / f32(game.player.monsters[0].stMax)
	for i:=0;i<int(ratio * 200);i+=1 {
		raylib.ImageDrawPixel(&img, i32(i), 0, {255,232,61,255})
	}
	game.barSt = raylib.LoadTextureFromImage(img)
	raylib.UnloadImage(img)
	raylib.DrawTexturePro(
		game.barSt,
		{0,0,f32(img.width),f32(img.height)},
		{posX + (160 * screenRatio), posY + (307 * screenRatio),(256 * screenRatio),(16 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
	//* Stamina
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v/%v", game.player.monsters[0].stCur, game.player.monsters[0].stMax)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (288 * screenRatio), posY + (309 * screenRatio)},
		{((f32(len(str)) * 1.25) * (16 * screenRatio)) / 2, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Atk Text
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v   %v", game.localization["atk"], game.player.monsters[0].atk)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (100 * screenRatio), posY + (351 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Def Text
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v   %v", game.localization["def"], game.player.monsters[0].def)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (100 * screenRatio), posY + (381 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* SpAtk Text
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v %v", game.localization["spatk"], game.player.monsters[0].spAtk)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (100 * screenRatio), posY + (411 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* SpDef Text
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v %v", game.localization["spdef"], game.player.monsters[0].spDef)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (100 * screenRatio), posY + (441 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Spd Text
	strings.builder_reset(&builder)
	str = fmt.sbprintf(&builder, "%v   %v", game.localization["spd"], game.player.monsters[0].spd)
	cstr = strings.clone_to_cstring(str)
	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (100 * screenRatio), posY + (471 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	delete(str)
	delete(cstr)
}