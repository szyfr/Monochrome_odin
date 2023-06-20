package ui


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"

import "vendor:raylib"

import "../../../game"


//= Procedures
draw_battle :: proc() {
	if game.battleData != nil {
		//* Player Status
		draw_player_status()
		draw_player_attacks()
		//* Enemy Status
		draw_enemy_status()
		
		//* Infobox
		draw_infobox()
	}
}

draw_player_status :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = 10
	posY : f32 = 10

	//* Draw box
	raylib.DrawTextureNPatch(
		game.statusboxUI,
		game.boxUI_npatch,
		{posX * screenRatio, posY * screenRatio, 342 * screenRatio, 144 * screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Draw name
	monsterName := game.localization[reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species)]
	raylib.DrawTextPro(
		game.font,
		monsterName,
		{(posX * screenRatio) + (40 * screenRatio), (posY * screenRatio) + (40 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Draw HP bar
	draw_bar(0, {posX + 40, posY +  68}, {198, 16}, &game.battleData.playerTeam[game.battleData.currentPlayer], SHOW_STAT|SHOW_AMOUNT)
	//* Draw Stamina bar
	draw_bar(1, {posX + 40, posY +  88}, {198, 16}, &game.battleData.playerTeam[game.battleData.currentPlayer], SHOW_STAT|SHOW_AMOUNT)
	//* Draw Experience bar
	draw_bar(2, {posX + 40, posY + 116}, {258, 12}, &game.battleData.playerTeam[game.battleData.currentPlayer], 0)
}

draw_player_attacks :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = 10
	posY : f32 = (f32(game.screenHeight) - (166 * screenRatio)) / screenRatio

	//* Draw box
	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX * screenRatio, posY * screenRatio, 342 * screenRatio, 156 * screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Compile text
	builder : strings.Builder
	str : string
	defer delete(str)
	cstr : cstring
	defer delete(cstr)

	attack1 := strings.to_pascal_case(reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].attacks[0]))
	if attack1 == "None" do attack1 = "---"
	attack2 := strings.to_pascal_case(reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].attacks[1]))
	if attack2 == "None" do attack2 = "---"
	attack3 := strings.to_pascal_case(reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].attacks[2]))
	if attack3 == "None" do attack3 = "---"
	attack4 := strings.to_pascal_case(reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].attacks[3]))
	if attack4 == "None" do attack4 = "---"

	str = fmt.sbprintf(
		&builder,
		"Q: %v\nW: %v\nE: %v\nR: %v",
		attack1,
		attack2,
		attack3,
		attack4,
	)
	cstr = strings.clone_to_cstring(str)


	//* Draw text
	raylib.DrawTextPro(
		game.font,
		cstr,
		{(posX * screenRatio) + (40 * screenRatio), (posY * screenRatio) + (40 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
}

draw_enemy_status :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = (f32(game.screenWidth) - (352 * screenRatio)) / screenRatio
	posY : f32 = 10

	//* Draw box
	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX * screenRatio, posY * screenRatio, 342 * screenRatio, 144 * screenRatio},
		{0,0},
		0,
		raylib.WHITE,
	)

	//* Draw name
	monsterName := game.localization[reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species)]
	raylib.DrawTextPro(
		game.font,
		monsterName,
		{(posX * screenRatio) + (40 * screenRatio), (posY * screenRatio) + (40 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)

	//* Only show HP and Stamina numbers for enemies if on Easy
	tags : u8 = SHOW_STAT
	if game.difficulty == .easy do tags += SHOW_AMOUNT

	//* Draw HP bar
	draw_bar(0, {posX + 40, posY +  68}, {198, 16}, &game.battleData.playerTeam[game.battleData.currentPlayer], tags)
	//* Draw Stamina bar
	draw_bar(1, {posX + 40, posY +  88}, {198, 16}, &game.battleData.playerTeam[game.battleData.currentPlayer], tags)
}

draw_infobox :: proc() {
	if game.battleData.playerAction == .info && game.battleData.infoText != "" {
		screenWidth_4	:= (f32(game.screenWidth) / 4)
		screenHeight_4	:= (f32(game.screenHeight) / 4)
		posX : f32 = 10
		posY : f32 = f32(game.screenHeight) - screenHeight_4
		screenRatio := f32(game.screenHeight) / 720

		raylib.DrawTextureNPatch(
			game.boxUI,
			game.boxUI_npatch,
			{posX, posY, f32(game.screenWidth) - screenWidth_4, f32(game.screenHeight) - screenHeight_4},
			{0,0},
			0,
			raylib.WHITE,
		)

		raylib.DrawTextPro(
			game.font,
			game.battleData.infoText,
			{posX + (40 * screenRatio), posY + (50 * screenRatio)},
			{0, 0},
			0,
			(16 * screenRatio),
			5,
			{56,56,56,255},
		)
	}
}