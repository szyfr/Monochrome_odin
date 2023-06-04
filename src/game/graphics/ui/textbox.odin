package ui


//= Imports
import "core:fmt"
import "core:strings"
import "core:reflect"

import "vendor:raylib"

import "../../../game"
import "../../../settings"
import "../../audio"


//= Procedures
draw_textbox :: proc() {
	if game.eventmanager.textbox.state != .inactive {
		screenWidth_2	:= (f32(game.screenWidth) / 2)
		screenWidth_3	:= (f32(game.screenWidth) / 3)
		screenWidth_4	:= (f32(game.screenWidth) / 4)
		screenHeight_4	:= (f32(game.screenHeight) / 4)
		screenRatio		:= (f32(game.screenHeight) / 720)

		posX := screenWidth_4
		posY := f32(game.screenHeight) - screenHeight_4
		
		raylib.DrawTextureNPatch(
			game.boxUI,
			game.boxUI_npatch,
			{posX, posY, screenWidth_2, screenHeight_4},
			{0,0},
			0,
			raylib.WHITE,
		)

		nlCount := f32(strings.count(game.eventmanager.textbox.targetText, "\n"))
		textY	:= (posY + (50 * screenRatio)) + ((2 - nlCount) * 15)
		text	:= strings.clone_to_cstring(game.eventmanager.textbox.currentText)
		raylib.DrawTextEx(
			game.font,
			text,
			{posX + 50, textY},
			21.3333 * screenRatio,
			1,
			{56,56,56,255},
		)
		delete(text)

		if game.eventmanager.textbox.hasChoice && game.eventmanager.textbox.currentText == game.eventmanager.textbox.targetText {
			raylib.DrawTextureNPatch(
				game.boxUI,
				game.boxUI_npatch,
				{
					posX + screenWidth_3,
					posY - screenHeight_4,
					screenWidth_2 - screenWidth_3,
					screenHeight_4,
				},
				{0,0},
				0,
				raylib.WHITE,
			)

			for i:=0;i<len(game.eventmanager.textbox.choiceList);i+=1 {
				raylib.DrawTextEx(
					game.font,
					game.eventmanager.textbox.choiceList[i].text^,
					{
						posX + screenWidth_3 + (80 * screenRatio),
						posY - screenHeight_4 + ((60 + (64*f32(i))) * screenRatio),
					},
					21.3333 * screenRatio,
					5,
					{56,56,56,255},
				)
			}
			raylib.DrawTexturePro(
				game.pointer,
				{0,0,8,8},
				{
					posX + screenWidth_3 + (40 * screenRatio),
					posY - screenHeight_4 + ((60 + (64*f32(game.eventmanager.textbox.curPosition))) * screenRatio),
					32,32,
				},
				{0,0},
				0,
				raylib.WHITE,
			)

			//* Controls
			if settings.is_key_pressed("up") {
				if game.eventmanager.textbox.curPosition == 0 do game.eventmanager.textbox.curPosition = len(game.eventmanager.textbox.choiceList)-1
				else do game.eventmanager.textbox.curPosition -= 1
			}
			if settings.is_key_pressed("down") {
				if game.eventmanager.textbox.curPosition == len(game.eventmanager.textbox.choiceList)-1 do game.eventmanager.textbox.curPosition = 0
				else do game.eventmanager.textbox.curPosition += 1
			}
		}

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
				audio.play_sound("button")
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
	newText		: string,
	hasChoice	: bool = false,
	choiceList	: [dynamic]game.Choice = nil,
	total		: int = 0,
) {
	textbox := &game.eventmanager.textbox

	textbox.state = .active
	textbox.currentText = ""
	textbox.targetText = newText

	refName	: string
	if game.player.monsters[0].nickname != "" do refName = strings.clone_from_cstring(game.player.monsters[0].nickname)
	else do refName = strings.to_pascal_case(reflect.enum_string(game.player.monsters[0].species))

	refEnemy : string
	// TODO
	//if game.battleStruct == nil do refEnemy = "TRAINER NOT FOUND"
	//else do refEnemy = strings.clone_from_cstring(game.localization[game.battleStruct.enemyName])
	

	refEnemyName : string
	// TODO
	//if game.battleStruct == nil do refEnemyName = "MONSTER NOT FOUND"
	//else do refEnemyName = strings.to_pascal_case(reflect.enum_string(game.battleStruct.enemyMonsterList[0].species))

	builder : strings.Builder

	refLevel := strings.clone(fmt.sbprintf(&builder,"%v",game.player.monsters[0].level))
	strings.builder_reset(&builder)

	refExperience : string
	// TODO
	//if game.battleStruct == nil do refExperience = "0"
	//else do refExperience = fmt.sbprintf(&builder,"%v",game.battleStruct.experience)
	
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{ENEMY_TRAINER}",	refEnemy)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{ENEMY_MONSTER_0_NAME}",	refName)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{MONSTER_0_NAME}",	refName)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{MONSTER_0_LEVEL}",refLevel)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{EXPERIENCE}",		refExperience)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{PLAYER_NAME}",	game.eventmanager.playerName)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{RIVAL_NAME}",		game.eventmanager.rivalName)
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{PRO_PERSONAL}",	game.eventmanager.playerPronouns[0])
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{PRO_OBJECTIVE}",	game.eventmanager.playerPronouns[1])
	textbox.targetText, _ = strings.replace_all(textbox.targetText, "{PRO_POSSESSIVE}",	game.eventmanager.playerPronouns[2])

	delete(refName)
	delete(refLevel)

	textbox.timer = 0
	textbox.position = 0
	textbox.pause = 0
	textbox.hasChoice = hasChoice
	textbox.choiceList = choiceList
}