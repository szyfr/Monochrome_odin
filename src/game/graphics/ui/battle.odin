package ui


//= Imports
import "core:reflect"

import "vendor:raylib"

import "../../../game"


//= Procedures
draw_battle :: proc() {
	if game.battleData != nil {
		//* Player Status
		draw_player_status()
		//* Enemy Status
		draw_enemy_status()
		
		//* Infobox
		draw_infobox()
	}
}

draw_player_status :: proc() {
	screenWidth_3	:= (f32(game.screenWidth) / 3.75)
	screenHeight_5	:= (f32(game.screenHeight) / 5)
	posX : f32 = 10
	posY : f32 = 10
	screenRatio := f32(game.screenHeight) / 720

	//* Draw box
	raylib.DrawTextureNPatch(
		game.statusboxUI,
		game.boxUI_npatch,
		{posX, posY, screenWidth_3, screenHeight_5},
		{0,0},
		0,
		raylib.WHITE,
	)
	//* Draw name
	monsterName := game.localization[reflect.enum_string(game.battleData.playerTeam[game.battleData.currentPlayer].species)]
	raylib.DrawTextPro(
		game.font,
		monsterName,
		{posX + (40 * screenRatio), posY + (40 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
	//* Draw HP bar
	draw_bar(0, -30, 37, 197, 16, 0, 1)
	//* Draw Stamina bar
	draw_bar(1, -30, 57, 197, 16, 0, 1)
	//* Draw Experience bar
	draw_bar(2, -30, 85, 257, 12, 0, 2)
}

draw_enemy_status :: proc() {}

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