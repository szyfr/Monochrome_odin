package ui


//= Imports
import "core:fmt"
import "core:reflect"
import "core:strings"
import "core:math"

import "vendor:raylib"

import "../../../game"
import "../../monsters"


//= Procedures
draw_battle :: proc() {
	if game.battleData != nil {
		//* Player Status
		draw_player_status()
		//* Player UI
		draw_player_actions()
		draw_player_attacks()
		draw_player_selection()
		//* Enemy Status
		draw_enemy_status()

		//* Draw current turn marker
		if game.battleData.playersTurn do raylib.DrawTexturePro( game.pointer, {0,0,8,8}, {scale(359),scale(119),scale(32),scale(32)}, {8,8}, 180, raylib.WHITE )
		else do raylib.DrawTexturePro( game.pointer, {0,0,8,8}, {scale(918),scale(119),scale(32),scale(32)}, {8,8}, 0, raylib.WHITE )
		
		//* Infobox
		draw_infobox()

		//* Messages
		draw_messages()
	}
}

draw_player_status :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = 10
	posY : f32 = 10

	//* Draw box
	draw_npatch({posX, posY, 342, 144}, "textbox_player_status")

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

	//* Draw stat changes
	player := &game.battleData.playerTeam[game.battleData.currentPlayer]
	if player.statChanges[0] != 0 {
		draw_sprite({posX + 20, 160, 32, 32}, {0,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 20, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 20, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 20, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if player.statChanges[1] != 0 {
		draw_sprite({posX + 52, 160, 32, 32}, {1,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 52, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 52, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 52, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if player.statChanges[2] != 0 {
		draw_sprite({posX + 84, 160, 32, 32}, {2,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 84, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 84, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 84, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if player.statChanges[3] != 0 {
		draw_sprite({posX + 116, 160, 32, 32}, {3,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 116, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 116, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 116, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if player.statChanges[4] != 0 {
		draw_sprite({posX + 148, 160, 32, 32}, {4,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 148, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 148, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 148, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if player.statChanges[5] != 0 {
		draw_sprite({posX + 180, 160, 32, 32}, {5,2}, {247,82,49,255}, "status_icons")
		if player.statChanges[1] > 0 do draw_sprite({posX + 180, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 180, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 180, 160, 32, 32}, {math.abs(f32(player.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
}

draw_player_attacks :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = 10
	posY : f32 = (f32(game.screenHeight) - (134 * screenRatio)) / screenRatio

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

draw_player_actions :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = 310
	posY : f32 = (f32(game.screenHeight) - (134 * screenRatio)) / screenRatio

	//* Draw box
	raylib.DrawTextureNPatch(
		game.boxUI,
		game.boxUI_npatch,
		{posX * screenRatio, posY * screenRatio, 278 * screenRatio, 156 * screenRatio},
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

	monster := &game.battleData.playerTeam[game.battleData.currentPlayer]

	str = fmt.sbprintf(
		&builder,
		"1: Move\n\t\t\t%v/%v",
		monster.movesCur - len(game.battleData.moveArrowList),
		monster.movesMax,
	)
	cstr = strings.clone_to_cstring(str)

	//* Draw text
	raylib.DrawTextPro(
		game.font,
		//"1: Info\n2: Move\n3: Item\n4: Switch",
		//"1: Move\n\t",
		cstr,
		{(posX * screenRatio) + (40 * screenRatio), (posY * screenRatio) + (40 * screenRatio)},
		{0, 0},
		0,
		(16 * screenRatio),
		5,
		{56,56,56,255},
	)
}

draw_player_selection :: proc() {
	element1_posX : f32 = 10
	element2_posX : f32 = 310

	posY : f32 = descale(f32(game.screenHeight) - scale(134))

	dest : raylib.Rectangle = {0,0,scale(16),scale(16)}
	#partial switch game.battleData.playerAction {
		case .interaction:
			dest.x = scale(394)
			dest.y = scale(630)
		case .item:
			dest.x = scale(394)
			dest.y = scale(654)
		case .switch_in:
			dest.x = scale(394)
			dest.y = scale(678)

		case .attack1:
			dest.x = scale( 94)
			dest.y = scale(630)
		case .attack2:
			dest.x = scale( 94)
			dest.y = scale(654)
		case .attack3:
			dest.x = scale( 94)
			dest.y = scale(678)
		case .attack4:
			dest.x = scale( 94)
			dest.y = scale(702)
	}

	//(texture: Texture2D, source, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color)
	raylib.DrawTexturePro(
		game.pointer,
		{0,0,8,8},
		dest,
		{8,8},
		0,
		raylib.WHITE,
	)
}

scale :: proc( input : f32 ) -> f32 {
	return input * (f32(game.screenHeight) / 720)
}
descale :: proc( input : f32 ) -> f32 {
	return input / (f32(game.screenHeight) / 720)
}

draw_enemy_status :: proc() {
	screenRatio := f32(game.screenHeight) / 720
	posX : f32 = (f32(game.screenWidth) - (352 * screenRatio)) / screenRatio
	posY : f32 = 10

	//* Draw box
	draw_npatch({posX, posY, 342, 144}, "textbox_general")

	//* Draw name
	monsterName := game.localization[reflect.enum_string(game.battleData.enemyTeam[game.battleData.currentEnemy].species)]
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
	draw_bar(0, {posX + 40, posY +  68}, {198, 16}, &game.battleData.enemyTeam[game.battleData.currentEnemy], tags)
	//* Draw Stamina bar
	draw_bar(1, {posX + 40, posY +  88}, {198, 16}, &game.battleData.enemyTeam[game.battleData.currentEnemy], tags)

	//* Draw stat changes
	enemy := &game.battleData.enemyTeam[game.battleData.currentEnemy]
	if enemy.statChanges[0] != 0 {
		draw_sprite({posX + 20, 160, 32, 32}, {0,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[0] > 0 do draw_sprite({posX + 20, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 20, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 20, 160, 32, 32}, {math.abs(f32(enemy.statChanges[0]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if enemy.statChanges[1] != 0 {
		draw_sprite({posX + 52, 160, 32, 32}, {1,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[1] > 0 do draw_sprite({posX + 52, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 52, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 52, 160, 32, 32}, {math.abs(f32(enemy.statChanges[1]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if enemy.statChanges[2] != 0 {
		draw_sprite({posX + 84, 160, 32, 32}, {2,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[2] > 0 do draw_sprite({posX + 84, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 84, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 84, 160, 32, 32}, {math.abs(f32(enemy.statChanges[2]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if enemy.statChanges[3] != 0 {
		draw_sprite({posX + 116, 160, 32, 32}, {3,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[3] > 0 do draw_sprite({posX + 116, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 116, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 116, 160, 32, 32}, {math.abs(f32(enemy.statChanges[3]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if enemy.statChanges[4] != 0 {
		draw_sprite({posX + 148, 160, 32, 32}, {4,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[4] > 0 do draw_sprite({posX + 148, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 148, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 148, 160, 32, 32}, {math.abs(f32(enemy.statChanges[4]))-1,0}, {56,56,56,255}, "status_icons")
	}
	if enemy.statChanges[5] != 0 {
		draw_sprite({posX + 180, 160, 32, 32}, {5,2}, {247,82,49,255}, "status_icons")
		if enemy.statChanges[5] > 0 do draw_sprite({posX + 180, 160, 32, 32}, {1,1}, {56,56,56,255}, "status_icons")
		else do draw_sprite({posX + 180, 160, 32, 32}, {0,1}, {56,56,56,255}, "status_icons")
		draw_sprite({posX + 180, 160, 32, 32}, {math.abs(f32(enemy.statChanges[5]))-1,0}, {56,56,56,255}, "status_icons")
	}
}

draw_infobox :: proc() {
	if game.battleData.playerAction == .interaction && game.battleData.infoText != "" {
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

draw_messages :: proc() {
	offset : raylib.Vector2 = {f32(game.screenWidth) - 400, f32(game.screenHeight) - 200}

	for i:=0;i<len(game.battleData.messages);i+=1 {
		draw_npatch({offset.x, offset.y, 400, 88}, "textbox_general")
		raylib.DrawTextPro(
			game.font,
			game.battleData.messages[i].str,
			{offset.x + (30 * game.screenRatio), offset.y + (40 * game.screenRatio)},
			{0, 0},
			0,
			(16 * game.screenRatio),
			5,
			{56,56,56,255},
		)

		offset -= {0, 100}
		game.battleData.messages[i].time -= 1
		if game.battleData.messages[i].time <= 0 do remove_message(i)
	}
}

add_message :: proc( str : cstring ) {
	append(&game.battleData.messages, game.Message{str, 200})
}

remove_message :: proc( index : int ) {
	temp : [dynamic]game.Message

	for i:=0;i<len(game.battleData.messages);i+=1 {
		if i != index do append(&temp, game.battleData.messages[i])
	}

	delete(game.battleData.messages)
	game.battleData.messages = temp
}
