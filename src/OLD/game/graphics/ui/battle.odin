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

		if game.eventmanager.currentEvent == nil {
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
		}

		//* Levelup display
		if game.levelUpDisplay != nil do draw_levelup()

		//* Messages
		draw_messages()
	}
}

draw_player_status :: proc() {
	monster := &game.battleData.playerTeam[game.battleData.currentPlayer]
	posX : f32 = 10
	posY : f32 = 10

	//* Draw box
	draw_npatch({posX, posY, 342, 144}, "textbox_player_status")

	//* Draw name
	monsterName := game.localization[reflect.enum_string(monster.species)]
	draw_text({posX + 40, posY + 40, 258, 16}, monsterName)

	//* Draw bars
	draw_bar_battle({posX + 40, posY +  68, 198, 16}, monster, 0, true)
	draw_bar_battle({posX + 40, posY +  88, 198, 16}, monster, 1, true)
	draw_bar_battle({posX + 40, posY + 116, 198, 16}, monster, 2, true)

	//* Draw stat changes
	draw_stat_changes(monster, 0, {posX +  20, 160})
	draw_stat_changes(monster, 1, {posX +  52, 160})
	draw_stat_changes(monster, 2, {posX +  84, 160})
	draw_stat_changes(monster, 3, {posX + 116, 160})
	draw_stat_changes(monster, 4, {posX + 148, 160})
	draw_stat_changes(monster, 5, {posX + 180, 160})
}

draw_player_attacks :: proc() {
	posX : f32 = 10
	posY : f32 = (f32(game.screenHeight) - (134 * game.screenRatio)) / game.screenRatio

	//* Draw box
	draw_npatch({posX, posY, 342, 156}, "textbox_general")

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
	draw_text({posX + 48, posY + 40, 342, 156}, cstr, true)
}

draw_player_actions :: proc() {
	monster := &game.battleData.playerTeam[game.battleData.currentPlayer]
	posX : f32 = 310
	posY : f32 = (f32(game.screenHeight) - (134 * game.screenRatio)) / game.screenRatio

	//* Draw box
	draw_npatch({posX, posY, 278, 156}, "textbox_general")

	//* Compile text
	builder : strings.Builder
	str : string
	defer delete(str)
	cstr : cstring
	defer delete(cstr)

	str = fmt.sbprintf(
		&builder,
		"   Move\n\t\t\t%v/%v",
		monster.movesCur - len(game.battleData.moveArrowList),
		monster.movesMax,
	)
	cstr = strings.clone_to_cstring(str)

	//* Draw text
	draw_text({posX + 48, posY + 40, 342, 156}, cstr, true)
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

	raylib.DrawTexturePro(
		game.pointer,
		{0,0,8,8},
		dest,
		{8,8},
		0,
		raylib.WHITE,
	)
}

draw_enemy_status :: proc() {
	monster := &game.battleData.enemyTeam[game.battleData.currentEnemy]
	posX : f32 = (f32(game.screenWidth) - (352 * game.screenRatio)) / game.screenRatio
	posY : f32 = 10

	//* Draw box
	draw_npatch({posX, posY, 342, 144}, "textbox_general")

	//* Draw name
	monsterName := game.localization[reflect.enum_string(monster.species)]
	draw_text({posX + 40, posY + 40, 258, 16}, monsterName)

	//* Draw bars
	draw_bar_battle({posX + 40, posY +  68, 198, 16}, monster, 0, false)
	draw_bar_battle({posX + 40, posY +  88, 198, 16}, monster, 1, false)

	//* Draw stat changes
	draw_stat_changes(monster, 0, {posX +  20, 160})
	draw_stat_changes(monster, 1, {posX +  52, 160})
	draw_stat_changes(monster, 2, {posX +  84, 160})
	draw_stat_changes(monster, 3, {posX + 116, 160})
	draw_stat_changes(monster, 4, {posX + 148, 160})
	draw_stat_changes(monster, 5, {posX + 180, 160})
}

draw_infobox :: proc() {
	if game.battleData.playerAction == .interaction && game.battleData.infoText != "" {
		width	:= f32(game.screenWidth) - (f32(game.screenWidth) / 4)
		height	:= f32(game.screenHeight) - (f32(game.screenHeight) / 4)
		posX : f32 = 10
		posY : f32 = height

		draw_npatch({posX, posY, width, height}, "textbox_general")
		draw_text({posX + 40, posY + 40, width, height}, game.battleData.infoText)
	}
}

draw_levelup :: proc() {
	monster := &game.battleData.playerTeam[game.battleData.currentPlayer]
	posX : f32 = (f32(game.screenWidth) - (352 * game.screenRatio)) / game.screenRatio
	posY : f32 = 10

	draw_npatch({posX, posY, 342, 342}, "textbox_general")

	//* Compile text
	builder : strings.Builder
	str : string
	defer delete(str)
	cstr : cstring
	defer delete(cstr)

	strings.write_string(&builder, "Level  ")
	if game.levelUpDisplay.level < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.level <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.level)
	strings.write_string(&builder, " - ")
	if monster.level < 100 do strings.write_string(&builder, " ")
	if monster.level <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.level)
	strings.write_string(&builder, "\n\n")

	strings.write_string(&builder, "HP:    ")
	if game.levelUpDisplay.hp < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.hp <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.hp)
	strings.write_string(&builder, " - ")
	if monster.hpMax < 100 do strings.write_string(&builder, " ")
	if monster.hpMax <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.hpMax)
	strings.write_string(&builder, "\n")

	strings.write_string(&builder, "ST:    ")
	if game.levelUpDisplay.st < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.st <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.st)
	strings.write_string(&builder, " - ")
	if monster.stMax < 100 do strings.write_string(&builder, " ")
	if monster.stMax <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.stMax)
	strings.write_string(&builder, "\n\n")

	strings.write_string(&builder, "ATK:   ")
	if game.levelUpDisplay.atk < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.atk <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.atk)
	strings.write_string(&builder, " - ")
	if monster.atk < 100 do strings.write_string(&builder, " ")
	if monster.atk <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.atk)
	strings.write_string(&builder, "\n")

	strings.write_string(&builder, "DEF:   ")
	if game.levelUpDisplay.def < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.def <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.def)
	strings.write_string(&builder, " - ")
	if monster.def < 100 do strings.write_string(&builder, " ")
	if monster.def <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.def)
	strings.write_string(&builder, "\n")

	strings.write_string(&builder, "SPATK: ")
	if game.levelUpDisplay.spatk < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.spatk <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.spatk)
	strings.write_string(&builder, " - ")
	if monster.spAtk < 100 do strings.write_string(&builder, " ")
	if monster.spAtk <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.spAtk)
	strings.write_string(&builder, "\n")

	strings.write_string(&builder, "SPDEF: ")
	if game.levelUpDisplay.spdef < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.spdef <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.spdef)
	strings.write_string(&builder, " - ")
	if monster.spDef < 100 do strings.write_string(&builder, " ")
	if monster.spDef <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.spDef)
	strings.write_string(&builder, "\n")

	strings.write_string(&builder, "SPD:   ")
	if game.levelUpDisplay.spd < 100 do strings.write_string(&builder, " ")
	if game.levelUpDisplay.spd <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, game.levelUpDisplay.spd)
	strings.write_string(&builder, " - ")
	if monster.spd < 100 do strings.write_string(&builder, " ")
	if monster.spd <  10 do strings.write_string(&builder, " ")
	strings.write_int(&builder, monster.spd)

	str = strings.to_string(builder)
	cstr = strings.clone_to_cstring(str)

	//* Draw text
	draw_text({posX + 40, posY + 56, 342, 342}, cstr, true)
}


scale :: proc( input : f32 ) -> f32 {
	return input * (f32(game.screenHeight) / 720)
}
descale :: proc( input : f32 ) -> f32 {
	return input / (f32(game.screenHeight) / 720)
}
