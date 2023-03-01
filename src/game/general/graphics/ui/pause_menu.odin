package ui


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../../game"
import "../../../../game/general/settings"


//= Procedures
draw_pause_menu :: proc() {
	if game.player.pauseMenu {
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
			raylib.BLACK,
		)

		raylib.DrawTextEx(
			game.font,
			game.localization["pokemon"],
			{posX + 100, 120},
			24,
			5,
			raylib.BLACK,
		)

		raylib.DrawTextEx(
			game.font,
			game.localization["inventory"],
			{posX + 100, 180},
			24,
			5,
			raylib.BLACK,
		)

		raylib.DrawTextEx(
			game.font,
			game.localization["player"],
			{posX + 100, 240},
			24,
			5,
			raylib.BLACK,
		)

		raylib.DrawTextEx(
			game.font,
			game.localization["options"],
			{posX + 100, 300},
			24,
			5,
			raylib.BLACK,
		)

		raylib.DrawTextEx(
			game.font,
			game.localization["quit"],
			{posX + 100, 360},
			24,
			5,
			raylib.BLACK,
		)
	}
}