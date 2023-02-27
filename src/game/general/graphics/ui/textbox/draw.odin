package textbox


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../../../../game"
import "../../../../../game/general/settings"


//= Procedures
draw :: proc() {
	if game.eventmanager.textbox.state != .inactive {
		posX := f32(game.screenWidth) / 4
		posY := f32(game.screenHeight) - (f32(game.screenHeight) / 4)
		raylib.DrawTextureNPatch(
			game.box_ui,
			game.box_ui_npatch,
			{posX, posY, f32(game.screenWidth) / 2, f32(game.screenHeight) / 4},
			{0,0},
			0,
			raylib.WHITE,
		)

		text := strings.clone_to_cstring(game.eventmanager.textbox.currentText)
		raylib.DrawTextEx(
			game.font,
			text,
			{posX + 50, posY + 60},
			24,
			5,
			raylib.BLACK,
		)
		delete(text)

		game.eventmanager.textbox.timer += 1

		switch game.textSpeed {
			case 0: // Instant
				game.eventmanager.textbox.position = len(game.eventmanager.textbox.targetText)
				game.eventmanager.textbox.currentText = game.eventmanager.textbox.targetText
			
			case 1: // Fast
				if game.eventmanager.textbox.timer >= 4 {
					if game.eventmanager.textbox.position > len(game.eventmanager.textbox.targetText) do break
					progress_textbox()
				}
			case 2: // Medium
				if game.eventmanager.textbox.timer >= 8 {
					if game.eventmanager.textbox.position > len(game.eventmanager.textbox.targetText) do break
					progress_textbox()
				}
			case 3: // Slow
				if game.eventmanager.textbox.timer >= 12 {
					if game.eventmanager.textbox.position > len(game.eventmanager.textbox.targetText) do break
					progress_textbox()
				}
		}

		if settings.is_key_pressed("interact") && game.eventmanager.textbox.pause >= 2 {
			if game.eventmanager.textbox.position > len(game.eventmanager.textbox.targetText) {
				game.eventmanager.textbox.state = .finished
			} else {
				game.eventmanager.textbox.position = len(game.eventmanager.textbox.targetText)
				game.eventmanager.textbox.currentText = game.eventmanager.textbox.targetText
			}
		}
		game.eventmanager.textbox.pause += 1
	}
}

progress_textbox :: proc() {
	builder : strings.Builder
	strings.write_string(&builder, game.eventmanager.textbox.targetText[:game.eventmanager.textbox.position])
	game.eventmanager.textbox.currentText = strings.clone(strings.to_string(builder))
	strings.builder_destroy(&builder)

	game.eventmanager.textbox.position += 1
	game.eventmanager.textbox.timer		= 0
}

close_textbox :: proc() {
	textbox := &game.eventmanager.textbox

	textbox.state = .inactive
	textbox.currentText = ""
	textbox.targetText = ""
	textbox.timer = 0
	textbox.position = 0
}

reset_textbox :: proc() {
	textbox := &game.eventmanager.textbox

	textbox.state = .reset
	textbox.currentText = ""
	textbox.targetText = ""
	textbox.timer = 0
	textbox.position = 0
}

open_textbox :: proc(
	newText : string,
) {
	textbox := &game.eventmanager.textbox

	textbox.state = .active
	textbox.currentText = ""
	textbox.targetText = newText
	textbox.timer = 0
	textbox.position = 0
	textbox.pause = 0
}