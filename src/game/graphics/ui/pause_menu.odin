package ui


//= Imports
import "core:reflect"
import "core:strings"
import "core:fmt"

import "vendor:raylib"

import "../../../game"
import "../../audio"
import "../../monsters"
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
	screenWidth_8	:= (f32(game.screenWidth) / 8)
	screenHeight_8	:= (f32(game.screenHeight) / 8)
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
	draw_sprite(55, 60, 0)

	//* Names
	draw_names(280, 80, 0)

	//* Types
	draw_types(280, 160, 0)

	//* Level
	draw_lv(404, 214, 0)

	//* Experience bar
	draw_bar(2, 280, 224, 256, 16, 0, 0)

	//* Health bar
	draw_bar(0, 100, 286, 256, 16, 0, 1)
	//* Stamina bar
	draw_bar(1, 100, 311, 256, 16, 0, 1)

	//* Atk Text
	draw_stat(0, 100, 351, 0)
	//* Def Text
	draw_stat(1, 100, 381, 0)
	//* SpAtk Text
	draw_stat(2, 100, 411, 0)
	//* SpDef Text
	draw_stat(3, 100, 441, 0)
	//* Spd Text
	draw_stat(4, 100, 471, 0)
}

//@{private}
draw_stat :: proc( stat : u8, x, y : f32, monster : u8 ) {
	str : string
	defer delete(str)

	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720

	builder : strings.Builder
	switch stat {
		case 0: // Atk
			str = fmt.sbprintf(&builder, "%v   %v", game.localization["atk"], game.player.monsters[monster].atk)
		case 1: // Def
			str = fmt.sbprintf(&builder, "%v   %v", game.localization["def"], game.player.monsters[monster].def)
		case 2: // SpAtk
			str = fmt.sbprintf(&builder, "%v %v", game.localization["spatk"], game.player.monsters[monster].spAtk)
		case 3: // SpDef
			str = fmt.sbprintf(&builder, "%v %v", game.localization["spdef"], game.player.monsters[monster].spDef)
		case 4: // Spd
			str = fmt.sbprintf(&builder, "%v   %v", game.localization["spd"], game.player.monsters[monster].spd)
	}

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)

	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (x * screenRatio), posY + (y * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
	
}

draw_bar :: proc( bar : u8, x, y : f32, width, height : f32, monster : u8, style : u8 ) {
	barText : cstring
	barTexture : ^raylib.Texture
	barColor : raylib.Color

	builder : strings.Builder
	str : string
	defer delete(str)
	cstr : cstring
	defer delete(cstr)

	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720
	ratio, prevRatio : f32
	offset : f32

	switch bar {
		case 0: // Health
			barText = game.localization["hp"]
			ratio = f32(game.player.monsters[monster].hpCur) / f32(game.player.monsters[monster].hpMax)
			str = fmt.sbprintf(&builder, "%v/%v", game.player.monsters[monster].hpCur, game.player.monsters[monster].hpMax)
			prevRatio = game.barHpRat
			barTexture = &game.barHp
			barColor = {247,82,49,255}
		case 1: // Stamina
			barText = game.localization["st"]
			ratio = f32(game.player.monsters[monster].stCur) / f32(game.player.monsters[monster].stMax)
			str = fmt.sbprintf(&builder, "%v/%v", game.player.monsters[monster].stCur, game.player.monsters[monster].stMax)
			prevRatio = game.barStRat
			barTexture = &game.barSt
			barColor = {255,232,61,255}
		case 2: // Experience
			barText = game.localization["exp"]
			lv := f32(monsters.calculate_experience(game.player.monsters[monster].level, game.player.monsters[monster].rate))
			currentExp	:= f32(game.player.monsters[monster].experience)
			nextExp		:= f32(monsters.calculate_experience(game.player.monsters[monster].level+1, game.player.monsters[monster].rate))
			ratio = (currentExp - lv) / (nextExp - lv)
			str = fmt.sbprintf(&builder, "%v", game.player.monsters[monster].experience)
			prevRatio = game.barExpRat
			barTexture = &game.barExp
			barColor = {99,206,8,255}
	}

	//* Bar text
	if style == 1 {
		raylib.DrawTextPro(
			game.font,
			barText,
			{posX + (x * screenRatio), posY + (y * screenRatio)},
			{0, 0},
			0,
			(16 * screenRatio),
			5,
			{56,56,56,255},
		)
		offset = 60
	}

	//* Bar
	if prevRatio != ratio {
		raylib.UnloadTexture(barTexture^)
		img := raylib.ImageCopy(game.barImg)
		defer raylib.UnloadImage(img)

		//if style == 2 do raylib.ImageColorReplace(&img,{173,173,173,255},{222,255,222,255})

		for i:=0;i<int(ratio * 200);i+=1 do raylib.ImageDrawPixel(&img, i32(i), 0, barColor)

		barTexture^ = raylib.LoadTextureFromImage(img)

		switch bar {
			case 0:  game.barHpRat = ratio
			case 1:  game.barStRat = ratio
			case 2:  game.barExpRat = ratio
		}
	}

	barX := x + offset
	raylib.DrawTexturePro(
		barTexture^,
		{0,0,f32(barTexture.width),f32(barTexture.height)},
		{posX + (barX * screenRatio), posY + (y * screenRatio) - 4,(width * screenRatio),(height * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)

	if style != 2 {
		cstr = strings.clone_to_cstring(str)
		raylib.DrawTextPro(
			game.font,
			cstr,
			{posX + ((barX + (width / 2)) * screenRatio), posY + (y * screenRatio)},
			{((f32(len(str)) * 1.25) * (height * screenRatio)) / 2, 0},
			0,
			(16 * screenRatio),
			5,
			{56,56,56,255},
		)
	}
}

draw_types :: proc( x, y : f32, monster : u8 ) {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720

	rect : raylib.Rectangle = {48 * (f32(game.player.monsters[monster].elementalType1)-1),0,48,8}
	raylib.DrawTexturePro(
		game.elementalTypes,
		rect,
		{posX + (x * screenRatio), posY + (y * screenRatio),(128 * screenRatio),(21.333333 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)

	rect = {48 * (f32(game.player.monsters[monster].elementalType2)-1),0,48,8}
	raylib.DrawTexturePro(
		game.elementalTypes,
		rect,
		{posX + ((x + 128) * screenRatio), posY + (y * screenRatio),(128 * screenRatio),(21.333333 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
}

draw_names :: proc( x, y : f32, monster : u8 ) {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720
	offset : f32 = 0

	//* Nickname
	if game.player.monsters[monster].nickname != "" {
		raylib.DrawTextEx(
			game.font,
			game.player.monsters[monster].nickname,
			{posX + (x * screenRatio), posY + (y * screenRatio)},
			16 * screenRatio,
			5,
			{56,56,56,255},
		)
		offset += (32 * screenRatio)
	}

	//* Species
	raylib.DrawTextEx(
		game.font,
		game.localization[reflect.enum_string(game.player.monsters[monster].species)],
		{posX + (x * screenRatio), posY + (y * screenRatio) + offset},
		16 * screenRatio,
		5,
		{56,56,56,255},
	)
}

draw_lv :: proc( x, y : f32, monster : u8 ) {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720

	builder : strings.Builder
	str := fmt.sbprintf(&builder, "Lv%v", game.player.monsters[monster].level)
	defer delete(str)
	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)

	raylib.DrawTextPro(
		game.font,
		cstr,
		{posX + (x * screenRatio), posY + (y * screenRatio)},
		{(f32(len(str)) * (16 * screenRatio)) / 2, 12},
		0,
		16 * screenRatio,
		5,
		{56,56,56,255},
	)
}

draw_sprite :: proc( x, y : f32, monster : u8 ) {
	posX := f32(game.screenWidth) / 16
	posY := f32(game.screenHeight) / 16
	screenRatio := f32(game.screenHeight) / 720

	raylib.DrawTexturePro(
		game.monsterTextures[game.player.monsters[monster].species],
		{0,0,64,64},
		{posX + (x * screenRatio), posY + (y * screenRatio), (192 * screenRatio), (192 * screenRatio)},
		{0,0},
		0,
		raylib.WHITE,
	)
}